{ pkgs, ... }:
{
  name = "caddy";
  meta = with pkgs.lib.maintainers; {
    maintainers = [
      Br1ght0ne
      stepbrobd
    ];
  };

  nodes = {
    webserver =
      { pkgs, ... }:
      {
        services.caddy.enable = true;
        services.caddy.extraConfig = ''
          http://localhost {
            encode gzip

            file_server
            root * ${
              pkgs.runCommand "testdir" { } ''
                mkdir "$out"
                echo hello world > "$out/example.html"
              ''
            }
          }
        '';
        services.caddy.enableReload = true;

        specialisation.config-reload.configuration = {
          services.caddy.extraConfig = ''
            http://localhost:8080 {
            }
          '';
        };
        specialisation.multiple-configs.configuration = {
          services.caddy.virtualHosts = {
            "http://localhost:8080" = { };
            "http://localhost:8081" = { };
          };
        };
        specialisation.multiple-hostnames.configuration = {
          services.caddy.virtualHosts = {
            "http://localhost:8080 http://localhost:8081" = { };
          };
        };
        specialisation.rfc42.configuration = {
          services.caddy.settings = {
            apps.http.servers.default = {
              listen = [ ":80" ];
              routes = [
                {
                  handle = [
                    {
                      body = "hello world";
                      handler = "static_response";
                      status_code = 200;
                    }
                  ];
                }
              ];
            };
          };
        };
        specialisation.explicit-config-file.configuration = {
          services.caddy.configFile = pkgs.writeText "Caddyfile" ''
            localhost:80

            respond "hello world"
          '';
        };
        specialisation.with-plugins.configuration = {
          services.caddy = {
            package = pkgs.caddy.withPlugins {
              plugins = [ "github.com/caddyserver/replace-response@v0.0.0-20241211194404-3865845790a7" ];
              hash = "sha256-RrB0/qXL0mCvkxKaz8zhj5GWKEtOqItXP2ASYz7VdMU=";
            };
            configFile = pkgs.writeText "Caddyfile" ''
              {
                order replace after encode
              }

              localhost:80 {
                respond "hello world"
                replace world caddy
              }
            '';
          };
        };
      };
  };

  testScript =
    { nodes, ... }:
    let
      explicitConfigFile = "${nodes.webserver.system.build.toplevel}/specialisation/explicit-config-file";
      justReloadSystem = "${nodes.webserver.system.build.toplevel}/specialisation/config-reload";
      multipleConfigs = "${nodes.webserver.system.build.toplevel}/specialisation/multiple-configs";
      multipleHostnames = "${nodes.webserver.system.build.toplevel}/specialisation/multiple-hostnames";
      rfc42Config = "${nodes.webserver.system.build.toplevel}/specialisation/rfc42";
      withPluginsConfig = "${nodes.webserver.system.build.toplevel}/specialisation/with-plugins";
    in
    ''
      url = "http://localhost/example.html"
      webserver.wait_for_unit("caddy")
      webserver.wait_for_open_port(80)


      with subtest("config is reloaded on nixos-rebuild switch"):
          webserver.succeed(
              "${justReloadSystem}/bin/switch-to-configuration test >&2"
          )
          webserver.wait_for_open_port(8080)
          webserver.fail("journalctl -u caddy | grep -q -i stopped")
          webserver.succeed("journalctl -u caddy | grep -q -i reloaded")

      with subtest("multiple configs are correctly merged"):
          webserver.succeed(
              "${multipleConfigs}/bin/switch-to-configuration test >&2"
          )
          webserver.wait_for_open_port(8080)
          webserver.wait_for_open_port(8081)

      with subtest("a virtual host with multiple hostnames works"):
          webserver.succeed(
              "${multipleHostnames}/bin/switch-to-configuration test >&2"
          )
          webserver.wait_for_open_port(8080)
          webserver.wait_for_open_port(8081)

      with subtest("rfc42 settings config"):
          webserver.succeed(
              "${rfc42Config}/bin/switch-to-configuration test >&2"
          )
          webserver.wait_for_open_port(80)
          webserver.succeed("curl http://localhost | grep hello")

      with subtest("explicit configFile"):
          webserver.succeed(
              "${explicitConfigFile}/bin/switch-to-configuration test >&2"
          )
          webserver.wait_for_open_port(80)
          webserver.succeed("curl http://localhost | grep hello")

      with subtest("plugins are correctled installed and configurable"):
          webserver.succeed(
              "${withPluginsConfig}/bin/switch-to-configuration test >&2"
          )
          webserver.wait_for_open_port(80)
          webserver.succeed("curl http://localhost | grep caddy")
    '';
}
