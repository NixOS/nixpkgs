import ./make-test-python.nix (
  { pkgs, lib, ... }:
  {
    name = "nginx-njs";

    nodes.machine =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      {
        services.nginx = {
          enable = true;
          additionalModules = [ pkgs.nginxModules.njs ];
          commonHttpConfig = ''
            js_import http from ${builtins.toFile "http.js" ''
              function hello(r) {
                  r.return(200, "Hello world!");
              }
              export default {hello};
            ''};
          '';
          virtualHosts."localhost".locations."/".extraConfig = ''
            js_content http.hello;
          '';
        };
      };
    testScript = ''
      machine.wait_for_unit("nginx")

      response = machine.wait_until_succeeds("curl -fvvv -s http://127.0.0.1/")
      assert "Hello world!" == response, f"Expected 'Hello world!', got '{response}'"
    '';
  }
)
