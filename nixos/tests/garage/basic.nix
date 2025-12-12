{
  lib,
  mkNode,
  package,
  testScriptSetup,
  ...
}:
{
  name = "garage-basic";

  nodes = {
    single_node = mkNode {
      extraSettings =
        if (lib.versionAtLeast package.version "2") then
          {
            replication_factor = 1;
            consistency_mode = "consistent";
          }
        else
          {
            replication_mode = "none";
          };
    };
  };

  testScript = # python
    ''
      ${testScriptSetup}

      with subtest("Garage works as a single-node S3 storage"):
        single_node.wait_for_unit("garage.service")
        single_node.wait_for_open_port(3900)
        # Now Garage is initialized.
        single_node_id = get_node_id(single_node)
        apply_garage_layout(single_node, [f'-z qemutest -c 1G "{single_node_id}"'])
        # Now Garage is operational.
        test_bucket_writes(single_node)
        test_bucket_over_http(single_node)
    '';
}
