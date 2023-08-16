import ./make-test-python.nix ({ pkgs, ...} : {
  name = "influxdb2";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ offline ];
  };

  nodes.machine = { lib, ... }: {
    environment.systemPackages = [ pkgs.influxdb2-cli ];
    services.influxdb2.enable = true;
    services.influxdb2.provision = {
      enable = true;
      initialSetup = {
        organization = "default";
        bucket = "default";
        passwordFile = pkgs.writeText "admin-pw" "ExAmPl3PA55W0rD";
        tokenFile = pkgs.writeText "admin-token" "verysecureadmintoken";
      };
    };
  };

  testScript = { nodes, ... }:
    let
      tokenArg = "--token verysecureadmintoken";
    in ''
      machine.wait_for_unit("influxdb2.service")

      machine.fail("curl --fail -X POST 'http://localhost:8086/api/v2/signin' -u admin:wrongpassword")
      machine.succeed("curl --fail -X POST 'http://localhost:8086/api/v2/signin' -u admin:ExAmPl3PA55W0rD")

      out = machine.succeed("influx org list ${tokenArg}")
      assert "default" in out

      out = machine.succeed("influx bucket list ${tokenArg} --org default")
      assert "default" in out
    '';
})
