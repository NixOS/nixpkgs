{ config, pkgs, ... }:
{
  name = "Basic Omnom Test";
  meta = {
    inherit (pkgs.omnom.meta) maintainers;
  };

  nodes = {
    server =
      { pkgs, ... }:
      {
        imports = [
          ../common/x11.nix
          ./config.nix
        ];

        environment.systemPackages = [ pkgs.xdotool ];
      };
  };

  testScript =
    let
      port = toString config.nodes.server.services.omnom.port;
    in
    # python
    ''
      import re

      def open_omnom():
        # Add-ons Manager
        server.succeed("xdotool mousemove --sync 1221 83 click 1")
        server.sleep(10)
        # omnom
        server.succeed("xdotool mousemove --sync 877 184 click 1")
        server.sleep(10)


      service_url = "http://127.0.0.1:${port}/"

      server.start()
      server.wait_for_unit("omnom.service")
      server.wait_for_open_port(${port})
      server.succeed(f"curl -sf '{service_url}'")

      output = server.succeed("omnom create-user user user@example.com")
      match = re.search(r"Visit (.+?) to sign in", output)
      assert match is not None, "Login URL not found"
      login_url = match[1].replace("0.0.0.0", "127.0.0.1")

      output = server.succeed("omnom create-token user addon")
      match = re.search(r"Token (.+?) created", output)
      assert match is not None, "Addon token not found"
      token = match[1]

      server.wait_for_x()
      server.succeed(f"librewolf --new-window '{login_url}' >&2 &")
      server.wait_for_window("Omnom")

      open_omnom()

      # token
      server.succeed("xdotool mousemove --sync 943 345 click 1")
      server.succeed(f"xdotool type {token}")
      server.sleep(10)

      # url
      server.succeed("xdotool mousemove --sync 943 452 click 1")
      server.succeed(f"xdotool type '{service_url}'")
      server.sleep(10)

      # submit
      server.succeed("xdotool mousemove --sync 1156 485 click 1")
      server.sleep(10)

      open_omnom()

      # save
      server.succeed("xdotool mousemove --sync 1151 459 click 1")
      server.sleep(10)

      # refresh
      server.succeed("xdotool mousemove --sync 100 80 click 1")
      server.sleep(10)

      server.screenshot("home.png")

      # view bookmarks
      server.succeed("xdotool mousemove --sync 377 133 click 1")
      server.sleep(10)

      # view snapshot
      server.succeed("xdotool mousemove --sync 414 307 click 1")
      server.sleep(10)
      server.succeed("xdotool mousemove --sync 993 510 click 1")
      server.sleep(10)

      server.screenshot("screenshot.png")

      # view details
      server.succeed("xdotool mousemove --sync 400 230 click 1")
      server.sleep(10)

      server.screenshot("snapshot_details.png")
    '';
}
