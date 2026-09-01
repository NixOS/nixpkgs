{
  name = "bore";

  nodes = {
    serverStandalone = {
      services.bore = {
        server = {
          example.enable = true;
        };
      };
    };

    bothStandard = {
      services.bore = {
        server.example.enable = true;

        local.example = {
          enable = true;
          to = "0.0.0.0";
          local-port = 3000;
          remote-port = 4000;
        };
      };
    };

    bothWithSecret =
      { pkgs, ... }:
      {
        services.bore = {
          server.example = {
            secretFile = pkgs.writeText "server-secret" "super-secret-message!";
            enable = true;
          };

          local.example = {
            enable = true;
            to = "0.0.0.0";
            local-port = 3000;
            remote-port = 4000;
            secretFile = pkgs.writeText "local-secret" "super-secret-message!";
          };
        };
      };
  };

  testScript = ''
    with subtest("Standalone server"):
      serverStandalone.wait_for_unit("bore-server-example.service")
      serverStandalone.wait_for_open_port(7835, "0.0.0.0")

    with subtest("Server & Proxy running together"):
      bothStandard.wait_for_unit("bore-server-example.service")
      bothStandard.wait_for_open_port(7835, "0.0.0.0")

      bothStandard.wait_for_unit("bore-local-example.service")
      bothStandard.wait_for_open_port(4000, "0.0.0.0")

    with subtest("Server & Proxy + authentication secret"):
      bothWithSecret.wait_for_unit("bore-server-example.service")
      bothWithSecret.wait_for_open_port(7835, "0.0.0.0")

      bothWithSecret.wait_for_unit("bore-local-example.service")
      bothWithSecret.wait_for_open_port(4000, "0.0.0.0")
  '';
}
