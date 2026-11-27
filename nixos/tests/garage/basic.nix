{
  lib,
  mkNode,
  package,
  testScriptSetup,
  ...
}:
{
  name = "garage-${package.version}-basic";

  nodes = {
    single_node = mkNode {
      extraSettings =
        if (lib.versionAtLeast package.version "2") then
          {
            replication_factor = 1;
            consistency_mode = "consistent";
            admin.api_bind_addr = "[::1]:3903";
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

      ${lib.optionalString (lib.versionAtLeast package.version "2.6") ''
        with subtest("Garage serves the web admin UI"):
          single_node.wait_for_open_port(3903, "::1")
          assert "<title>Garage Web Admin</title>" in single_node.succeed("curl -fsSL http://[::1]:3903/")
      ''}
    '';
}
