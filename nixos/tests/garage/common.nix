{ ... }:
{
  _module.args.testScriptSetup = # python
    ''
      from typing import List
      from dataclasses import dataclass
      import re

      start_all()

      cur_version_regex = re.compile(r'Current cluster layout version: (?P<ver>\d*)')

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
         output = machine.succeed(f"garage key create {key_name}")
         return parse_api_key_data(output)

      def get_api_key(machine: Machine, key_pattern: str) -> S3Key:
         output = machine.succeed(f"garage key info {key_pattern}")
         return parse_api_key_data(output)

      def parse_api_key_data(text) -> S3Key:
        key_creation_regex = re.compile(r'Key name: \s*(?P<key_name>.*)|' r'Key ID: \s*(?P<key_id>.*)|' r'Secret key: \s*(?P<secret_key>.*)', re.IGNORECASE)
        fields = {}
        for match in key_creation_regex.finditer(text):
          for key, value in match.groupdict().items():
            if value:
              fields[key] = value.strip()
        try:
          return S3Key(**fields)
        except TypeError as e:
          raise ValueError(f"Cannot parse API key data. Missing required field(s): {e}")

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
    '';
}
