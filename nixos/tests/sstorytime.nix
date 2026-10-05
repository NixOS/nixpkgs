{ lib, ... }:
{
  name = "sstorytime";

  meta = {
    maintainers = lib.teams.ngi.members;
  };

  nodes.machine =
    { pkgs, ... }:
    {
      services.sstorytime = {
        enable = true;
        httpPort = 18080;
        httpsPort = 18443;
        database.createLocally = true;
      };

      environment.etc."sstorytime/test".source = pkgs.writeText "sstorytime-test" "extra-config-ok\n";
    };

  testScript =
    { nodes, ... }:
    let
      inherit (nodes.machine.services.sstorytime) package httpPort httpsPort;
    in
    ''
      start_all()

      machine.wait_for_unit("sstorytime.service")
      machine.wait_for_open_port(${toString httpPort})
      machine.wait_for_open_port(${toString httpsPort})

      machine.succeed("test -d /etc/sstorytime")
      machine.succeed("test -f /etc/sstorytime/arrows-LT-1.sst")
      machine.succeed("test -f /etc/sstorytime/closures.sst")
      machine.succeed("test -f /etc/sstorytime/test")
      machine.succeed("grep -q extra-config-ok /etc/sstorytime/test")

      machine.succeed("ln -s ${package.examples}/share/examples /tmp/examples")

      machine.succeed("sstorytime-run N4L -v -wipe -u /tmp/examples/SSTorytime.n4l")

      output = machine.succeed("sstorytime-run searchN4L -v SSTorytime")
      assert "notes about SSTorytime in N4L" in output, "Failed to search for term in graph."

      output = machine.succeed('sstorytime-run N4L -s -adj="pe" /tmp/examples/chinese.n4l')
      assert "Incidence summary of raw declarations" in output, "Failed to get relation sub-graph."

      output = machine.succeed('sstorytime-run N4L -s -adj="" /tmp/examples/Mary.n4l')
      assert "Incidence summary of raw declarations" in output, "Failed to summarize graph."
    '';
}
