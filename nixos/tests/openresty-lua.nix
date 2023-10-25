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
        services.nginx = {
          enable = true;
          package = pkgs.openresty;

          commonHttpConfig = ''
            lua_package_path '${luaPath};;';
          '';

          virtualHosts."default" = {
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
      '';
  })
