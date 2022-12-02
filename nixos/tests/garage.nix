import ./make-test-python.nix ({ pkgs, ...} :
let
    mkNode = { replicationMode, publicV6Address ? "::1" }: { pkgs, ... }: {
      networking.interfaces.eth1.ipv6.addresses = [{
        address = publicV6Address;
        prefixLength = 64;
      }];

      networking.firewall.allowedTCPPorts = [ 3901 3902 ];

      services.garage = {
        enable = true;
        settings = {
          replication_mode = replicationMode;

          rpc_bind_addr = "[::]:3901";
          rpc_public_addr = "[${publicV6Address}]:3901";
          rpc_secret = "5c1915fa04d0b6739675c61bf5907eb0fe3d9c69850c83820f51b4d25d13868c";

          s3_api = {
            s3_region = "garage";
            api_bind_addr = "[::]:3900";
            root_domain = ".s3.garage";
          };

          s3_web = {
            bind_addr = "[::]:3902";
            root_domain = ".web.garage";
            index = "index.html";
          };
        };
      };
      environment.systemPackages = [ pkgs.minio-client ];

      # Garage requires at least 1GiB of free disk space to run.
      virtualisation.diskSize = 2 * 1024;
    };


in {
  name = "garage";
  meta = {
    maintainers = with pkgs.lib.maintainers; [ raitobezarius ];
  };

  nodes = {
    single_node = mkNode { replicationMode = "none"; };
    node1 = mkNode { replicationMode = 3; publicV6Address = "fc00:1::1"; };
    node2 = mkNode { replicationMode = 3; publicV6Address = "fc00:1::2"; };
    node3 = mkNode { replicationMode = 3; publicV6Address = "fc00:1::3"; };
    node4 = mkNode { replicationMode = 3; publicV6Address = "fc00:1::4"; };
  };

  testScript = ''
    from typing import List
    from dataclasses import dataclass
    import re
    start_all()

    cur_version_regex = re.compile('Current cluster layout version: (?P<ver>\d*)')
    key_creation_regex = re.compile('Key name: (?P<key_name>.*)\nKey ID: (?P<key_id>.*)\nSecret key: (?P<secret_key>.*)')

    @dataclass
    class S3Key:
       key_name: str
       key_id: str
       secret_key: str

    @dataclass
    class GarageNode:
       node_id: str
       host: str

    def get_node_fqn(machine: Machine) -> GarageNode:
      node_id, host = machine.succeed("garage node id").split('@')
      return GarageNode(node_id=node_id, host=host)

    def get_node_id(machine: Machine) -> str:
      return get_node_fqn(machine).node_id

    def get_layout_version(machine: Machine) -> int:
      version_data = machine.succeed("garage layout show")
      m = cur_version_regex.search(version_data)
      if m and m.group('ver') is not None:
        return int(m.group('ver')) + 1
      else:
        raise ValueError('Cannot find current layout version')

    def apply_garage_layout(machine: Machine, layouts: List[str]):
       for layout in layouts:
          machine.succeed(f"garage layout assign {layout}")
       version = get_layout_version(machine)
       machine.succeed(f"garage layout apply --version {version}")

    def create_api_key(machine: Machine, key_name: str) -> S3Key:
       output = machine.succeed(f"garage key new --name {key_name}")
       m = key_creation_regex.match(output)
       if not m or not m.group('key_id') or not m.group('secret_key'):
          raise ValueError('Cannot parse API key data')
       return S3Key(key_name=key_name, key_id=m.group('key_id'), secret_key=m.group('secret_key'))

    def get_api_key(machine: Machine, key_pattern: str) -> S3Key:
       output = machine.succeed(f"garage key info {key_pattern}")
       m = key_creation_regex.match(output)
       if not m or not m.group('key_name') or not m.group('key_id') or not m.group('secret_key'):
           raise ValueError('Cannot parse API key data')
       return S3Key(key_name=m.group('key_name'), key_id=m.group('key_id'), secret_key=m.group('secret_key'))

    def test_bucket_writes(node):
      node.succeed("garage bucket create test-bucket")
      s3_key = create_api_key(node, "test-api-key")
      node.succeed("garage bucket allow --read --write test-bucket --key test-api-key")
      other_s3_key = get_api_key(node, 'test-api-key')
      assert other_s3_key.secret_key == other_s3_key.secret_key
      node.succeed(
        f"mc alias set test-garage http://[::1]:3900 {s3_key.key_id} {s3_key.secret_key} --api S3v4"
      )
      node.succeed("echo test | mc pipe test-garage/test-bucket/test.txt")
      assert node.succeed("mc cat test-garage/test-bucket/test.txt").strip() == "test"

    def test_bucket_over_http(node, bucket='test-bucket', url=None):
      if url is None:
         url = f"{bucket}.web.garage"

      node.succeed(f'garage bucket website --allow {bucket}')
      node.succeed(f'echo hello world | mc pipe test-garage/{bucket}/index.html')
      assert (node.succeed(f"curl -H 'Host: {url}' http://localhost:3902")).strip() == 'hello world'

    with subtest("Garage works as a single-node S3 storage"):
      single_node.wait_for_unit("garage.service")
      single_node.wait_for_open_port(3900)
      # Now Garage is initialized.
      single_node_id = get_node_id(single_node)
      apply_garage_layout(single_node, [f'-z qemutest -c 1 "{single_node_id}"'])
      # Now Garage is operational.
      test_bucket_writes(single_node)
      test_bucket_over_http(single_node)

    with subtest("Garage works as a multi-node S3 storage"):
      nodes = ('node1', 'node2', 'node3', 'node4')
      rev_machines = {m.name: m for m in machines}
      def get_machine(key): return rev_machines[key]
      for key in nodes:
        node = get_machine(key)
        node.wait_for_unit("garage.service")
        node.wait_for_open_port(3900)

      # Garage is initialized on all nodes.
      node_ids = {key: get_node_fqn(get_machine(key)) for key in nodes}

      for key in nodes:
        for other_key in nodes:
          if other_key != key:
            other_id = node_ids[other_key]
            get_machine(key).succeed(f"garage node connect {other_id.node_id}@{other_id.host}")

      # Provide multiple zones for the nodes.
      zones = ["nixcon", "nixcon", "paris_meetup", "fosdem"]
      apply_garage_layout(node1,
      [
        f'{ndata.node_id} -z {zones[index]} -c 1'
        for index, ndata in enumerate(node_ids.values())
      ])
      # Now Garage is operational.
      test_bucket_writes(node1)
      for node in nodes:
         test_bucket_over_http(get_machine(node))
  '';
})
