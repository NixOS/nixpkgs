{
  lib,
  mkNode,
  package,
  testScriptSetup,
  ...
}:
let
  extraSettings =
    if (lib.versionAtLeast package.version "2") then
      {
        replication_factor = 3;
        consistency_mode = "consistent";
      }
    else
      {
        replication_mode = "3";
      };
in
{
  name = "garage-3node-replication";

  nodes = {
    node1 = mkNode {
      inherit extraSettings;
      publicV6Address = "fc00:1::1";
    };
    node2 = mkNode {
      inherit extraSettings;
      publicV6Address = "fc00:1::2";
    };
    node3 = mkNode {
      inherit extraSettings;
      publicV6Address = "fc00:1::3";
    };
    node4 = mkNode {
      inherit extraSettings;
      publicV6Address = "fc00:1::4";
    };
  };

  testScript = # python
    ''
      ${testScriptSetup}

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
          f'{ndata.node_id} -z {zones[index]} -c 1G'
          for index, ndata in enumerate(node_ids.values())
        ])
        # Now Garage is operational.
        test_bucket_writes(node1)
        for node in nodes:
           test_bucket_over_http(get_machine(node))
    '';
}
