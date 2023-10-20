import ./make-test-python.nix ({ pkgs, lib, ... }:
  let
    lualibs = [
      pkgs.lua.pkgs.markdown
    ];

    getPath = lib: type: "${lib}/share/lua/${pkgs.lua.luaversion}/?.${type}";
    getLuaPath = lib: getPath lib "lua";
    luaPath = lib.concatStringsSep ";" (map getLuaPath lualibs);
  in
  {
    name = "openresty-lua";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ bbigras ];
    };

    nodes = {
      webserver = { pkgs, lib, ... }: {
        networking = {
          extraHosts = ''
            127.0.0.1 default.test
            127.0.0.1 sandbox.test
          '';
        };
        services.nginx = {
          enable = true;
          package = pkgs.openresty;

          commonHttpConfig = ''
            lua_package_path '${luaPath};;';
          '';

          virtualHosts."default.test" = {
            default = true;
            locations."/" = {
              extraConfig = ''
                default_type text/html;
                access_by_lua '
                  local markdown = require "markdown"
                  markdown("source")
                ';
              '';
            };
          };

          virtualHosts."sandbox.test" = {
            locations."/test1-write" = {
              extraConfig = ''
                content_by_lua_block {
                  local create = os.execute('${pkgs.coreutils}/bin/mkdir /tmp/test1-read')
                  local create = os.execute('${pkgs.coreutils}/bin/touch /tmp/test1-read/foo.txt')
                  local echo = os.execute('${pkgs.coreutils}/bin/echo worked > /tmp/test1-read/foo.txt')
                }
              '';
            };
            locations."/test1-read" = {
              root = "/tmp";
            };
            locations."/test2-write" = {
              extraConfig = ''
                content_by_lua_block {
                  local create = os.execute('${pkgs.coreutils}/bin/mkdir /var/web/test2-read')
                  local create = os.execute('${pkgs.coreutils}/bin/touch /var/web/test2-read/bar.txt')
                  local echo = os.execute('${pkgs.coreutils}/bin/echo error-worked > /var/web/test2-read/bar.txt')
                }
              '';
            };
            locations."/test2-read" = {
              root = "/var/web";
            };
          };
        };
      };
    };

    testScript = { nodes, ... }:
      ''
        url = "http://localhost"

        webserver.wait_for_unit("nginx")
        webserver.wait_for_open_port(80)

        http_code = webserver.succeed(
          f"curl -w '%{{http_code}}' --head --fail {url}"
        )
        assert http_code.split("\n")[-1] == "200"

        # This test checks the creation and reading of a file in sandbox mode.
        # Checking write in temporary folder
        webserver.succeed("$(curl -vvv http://sandbox.test/test1-write)")
        webserver.succeed('test "$(curl -fvvv http://sandbox.test/test1-read/foo.txt)" = worked')
        # Checking write in protected folder. In sandbox mode for the nginx service, the folder /var/web is mounted
        # in read-only mode.
        webserver.succeed("mkdir -p /var/web")
        webserver.succeed("chown nginx:nginx /var/web")
        webserver.succeed("$(curl -vvv http://sandbox.test/test2-write)")
        assert "404 Not Found" in machine.succeed(
            "curl -vvv -s http://sandbox.test/test2-read/bar.txt"
        )
      '';
  })
