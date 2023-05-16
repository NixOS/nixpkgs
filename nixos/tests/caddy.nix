import ./make-test-python.nix ({ pkgs, ... }: {
  name = "caddy";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ xfix Br1ght0ne ];
  };

  nodes = {
    webserver = { pkgs, lib, ... }: {
      services.caddy.enable = true;
      services.caddy.extraConfig = ''
        http://localhost {
          encode gzip

          file_server
          root * ${
            pkgs.runCommand "testdir" {} ''
              mkdir "$out"
              echo hello world > "$out/example.html"
            ''
          }
        }
      '';
<<<<<<< HEAD
      services.caddy.enableReload = true;
=======

      specialisation.etag.configuration = {
        services.caddy.extraConfig = lib.mkForce ''
          http://localhost {
            encode gzip

            file_server
            root * ${
              pkgs.runCommand "testdir2" {} ''
                mkdir "$out"
                echo changed > "$out/example.html"
              ''
            }
          }
        '';
      };
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD
      specialisation.rfc42.configuration = {
        services.caddy.settings = {
          apps.http.servers.default = {
            listen = [ ":80" ];
            routes = [{
              handle = [{
                body = "hello world";
                handler = "static_response";
                status_code = 200;
              }];
            }];
          };
        };
      };
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };
  };

  testScript = { nodes, ... }:
    let
<<<<<<< HEAD
      justReloadSystem = "${nodes.webserver.system.build.toplevel}/specialisation/config-reload";
      multipleConfigs = "${nodes.webserver.system.build.toplevel}/specialisation/multiple-configs";
      rfc42Config = "${nodes.webserver.system.build.toplevel}/specialisation/rfc42";
=======
      etagSystem = "${nodes.webserver.config.system.build.toplevel}/specialisation/etag";
      justReloadSystem = "${nodes.webserver.config.system.build.toplevel}/specialisation/config-reload";
      multipleConfigs = "${nodes.webserver.config.system.build.toplevel}/specialisation/multiple-configs";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    in
    ''
      url = "http://localhost/example.html"
      webserver.wait_for_unit("caddy")
      webserver.wait_for_open_port(80)


<<<<<<< HEAD
=======
      def check_etag(url):
          etag = webserver.succeed(
              "curl --fail -v '{}' 2>&1 | sed -n -e \"s/^< [Ee][Tt][Aa][Gg]: *//p\"".format(
                  url
              )
          )
          etag = etag.replace("\r\n", " ")
          http_code = webserver.succeed(
              "curl --fail --silent --show-error -o /dev/null -w \"%{{http_code}}\" --head -H 'If-None-Match: {}' {}".format(
                  etag, url
              )
          )
          assert int(http_code) == 304, "HTTP code is {}, expected 304".format(http_code)
          return etag


      with subtest("check ETag if serving Nix store paths"):
          old_etag = check_etag(url)
          webserver.succeed(
              "${etagSystem}/bin/switch-to-configuration test >&2"
          )
          webserver.sleep(1)
          new_etag = check_etag(url)
          assert old_etag != new_etag, "Old ETag {} is the same as {}".format(
              old_etag, new_etag
          )

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      with subtest("config is reloaded on nixos-rebuild switch"):
          webserver.succeed(
              "${justReloadSystem}/bin/switch-to-configuration test >&2"
          )
          webserver.wait_for_open_port(8080)
<<<<<<< HEAD
          webserver.fail("journalctl -u caddy | grep -q -i stopped")
          webserver.succeed("journalctl -u caddy | grep -q -i reloaded")
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

      with subtest("multiple configs are correctly merged"):
          webserver.succeed(
              "${multipleConfigs}/bin/switch-to-configuration test >&2"
          )
          webserver.wait_for_open_port(8080)
          webserver.wait_for_open_port(8081)
<<<<<<< HEAD

      with subtest("rfc42 settings config"):
          webserver.succeed(
              "${rfc42Config}/bin/switch-to-configuration test >&2"
          )
          webserver.wait_for_open_port(80)
          webserver.succeed("curl http://localhost | grep hello")
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    '';
})
