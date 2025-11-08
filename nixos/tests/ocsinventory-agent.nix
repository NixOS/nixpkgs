import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "ocsinventory-agent";

    nodes.machine =
      { pkgs, ... }:
      {
        services.ocsinventory-agent = {
          enable = true;
          settings = {
            debug = true;
            local = "/var/lib/ocsinventory-agent/reports";
            tag = "MY_INVENTORY_TAG";
          };
        };
      };

    testScript = ''
      path = "/var/lib/ocsinventory-agent/reports"

      # Run the agent to generate the inventory file in offline mode
      start_all()
      machine.succeed("mkdir -p {}".format(path))
      machine.wait_for_unit("ocsinventory-agent.service")
      machine.wait_until_succeeds("journalctl -u ocsinventory-agent.service | grep 'Inventory saved in'")

      # Fetch the path to the generated inventory file
      report_file = machine.succeed("find {}/*.ocs -type f | head -n1".format(path))

      with subtest("Check the tag value"):
        tag = machine.succeed(
          "${pkgs.libxml2}/bin/xmllint --xpath 'string(/REQUEST/CONTENT/ACCOUNTINFO/KEYVALUE)' {}".format(report_file)
        ).rstrip()
        assert tag == "MY_INVENTORY_TAG", f"tag is not valid, was '{tag}'"
    '';
  }
)
