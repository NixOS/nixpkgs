{ lib, ... }:
{
  name = "nginx-lua";

  meta.maintainers = [ lib.maintainers.kranzes ];

  nodes.machine = {
    services.nginx = {
      enable = true;
      lua = {
        enable = true;
        extraPackages = p: [
          p.lua-resty-lrucache
          p.lua-cjson
        ];
      };
      virtualHosts."localhost".locations."/" = {
        extraConfig = ''
          default_type text/plain;
          content_by_lua_block {
            local cache = require("resty.lrucache").new(8)
            cache:set("greeting", require("cjson").decode('"Hello world!"'))
            ngx.say((cache:get("greeting")))
          }
        '';
      };
    };
  };

  testScript = ''
    machine.wait_for_unit("nginx")
    machine.wait_for_open_port(80)

    response = machine.wait_until_succeeds("curl -fsS http://127.0.0.1/").strip()
    assert response == "Hello world!", f"Expected 'Hello world!', got '{response}'"
  '';
}
