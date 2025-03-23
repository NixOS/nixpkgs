import ../../make-test-python.nix (
  { lib, pkgs, ... }:

  let
    domain = "h2o.local";

    port = 8080;

    sawatdi_chao_lok = "สวัสดีชาวโลก";
  in
  {
    name = "h2o-mruby";

    meta = {
      maintainers = with lib.maintainers; [ toastal ];
    };

    nodes = {
      server =
        { pkgs, ... }:
        {
          services.h2o = {
            enable = true;
            package = pkgs.h2o.override { withMruby = true; };
            settings = {
              listen = port;
              hosts = {
                "${domain}" = {
                  paths = {
                    "/hello_world" = {
                      "mruby.handler" = # ruby
                        ''
                          Proc.new do |env|
                            [200, {'content-type' => 'text/plain'}, ["${sawatdi_chao_lok}"]]
                          end
                        '';
                    };
                    "/file_handler" = {
                      "mruby.handler-file" = ./file_handler.rb;
                    };
                  };
                };
              };
            };
          };

          networking.extraHosts = ''
            127.0.0.1 ${domain}
          '';
        };
    };

    testScript = # python
      ''
        server.wait_for_unit("h2o.service")

        hello_world = server.succeed("curl --fail-with-body http://${domain}:${builtins.toString port}/hello_world")
        assert "${sawatdi_chao_lok}" in hello_world

        file_handler = server.succeed("curl --fail-with-body http://${domain}:${builtins.toString port}/file_handler")
        assert "FILE_HANDLER" in file_handler
      '';
  }
)
