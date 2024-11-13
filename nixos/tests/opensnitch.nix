import ./make-test-python.nix ({ pkgs, ... }: {
  name = "opensnitch";

  meta = with pkgs.lib.maintainers; {
    maintainers = [ onny ];
  };

  nodes = {
    server =
      { ... }: {
        networking.firewall.allowedTCPPorts = [ 80 ];
        services.caddy = {
          enable = true;
          virtualHosts."localhost".extraConfig = ''
            respond "Hello, world!"
          '';
        };
      };

    clientBlocked =
      { ... }: {
        services.opensnitch = {
          enable = true;
          settings.DefaultAction = "deny";
        };
      };

    clientAllowed =
      { ... }: {
        services.opensnitch = {
          enable = true;
          settings.DefaultAction = "deny";
          rules = {
            curl = {
              name = "curl";
              enabled = true;
              action = "allow";
              duration = "always";
              operator = {
                type ="simple";
                sensitive = false;
                operand = "process.path";
                data = "${pkgs.curl}/bin/curl";
              };
            };
          };
        };
      };
  };

  testScript = ''
    start_all()
    server.wait_for_unit("caddy.service")
    server.wait_for_open_port(80)

    clientBlocked.wait_for_unit("opensnitchd.service")
    clientBlocked.fail("curl http://server")

    clientAllowed.wait_for_unit("opensnitchd.service")
    clientAllowed.succeed("curl http://server")
  '';
})
