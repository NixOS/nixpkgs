import ./make-test-python.nix (
  { lib, pkgs, ... }:

  {
    name = "goaccess";

    meta.maintainers = with lib.maintainers; [ bhankas ];

    nodes.machine =
      { config, ... }:
      {

        services.nginx = {
          enable = true;
          virtualHosts."localhost".locations."/" = {
            extraConfig = ''
              access_log /var/log/nginx/myapp-access.log combined;
            '';
          };
        };

        services.goaccess = {
          enable = true;
          sites = {
            myapp = {
              port = 7890;
              logFile = "/var/log/nginx/myapp-access.log";
              configFile = pkgs.writeText "goaccess.conf" ''
                log-format COMBINED
              '';
            };
          };
        };
      };

    testScript = ''
      start_all()
      machine.wait_for_unit("goaccess-myapp.service")
      # wait for goaccess to fully come up

      with subtest("goaccess service starts"):
          machine.wait_until_succeeds(
              "curl -sSfL http://127.0.0.1/goaccess/myapp/ > /dev/null",
              timeout=30
          )
    '';
  }
)
