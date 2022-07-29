import ./make-test-python.nix ({ pkgs, lib, ... }:
  rec {
    name = "lemmy";
    meta = with lib.maintainers; { maintainers = [ ]; };

    nodes.default = {
      services.lemmy = {
        enable = true;
        ui = {
          port = 1234;
          listenAddress = "127.0.0.0";
        };
        settings = {
          hostname = "example.com";
          port = 8536;
          listenAddress = "127.0.0.0";
        };
      };

      # pict-rs seems to need more than 1025114112 bytes
      virtualisation.memorySize = 2000;
    };

    testScript = ''
      # Wait for backend service to start
      machine.wait_for_unit("lemmy.service")
      machine.wait_for_open_port(${toString nodes.default.services.lemmy.settings.port})
      # Wait for webui services to start
      machine.wait_for_unit("lemmy-ui.service")
      machine.wait_for_open_port(${toString nodes.default.services.lemmy.ui.port})
      # curl the backend's API and the webui
      machine.succeed("curl --fail ${nodes.default.services.lemmy.settings.listenAddress}:${toString nodes.default.services.lemmy.settings.port}/api/v3/site")
      machine.succeed("curl --fail ${nodes.default.services.lemmy.ui.listenAddress}:${toString nodes.default.services.lemmy.ui.port}")
    '';
  })
