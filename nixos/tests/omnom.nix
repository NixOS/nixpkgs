{ lib, ... }:
let
  servicePort = 9090;
in
{
  name = "Basic Omnom Test";
  meta = {
    maintainers = lib.teams.ngi.members;
  };

  nodes = {
    server =
      { pkgs, ... }:
      {
        imports = [
          ./common/x11.nix
        ];

        services.omnom = {
          enable = true;
          openFirewall = true;

          port = servicePort;

          settings = {
            app = {
              disable_signup = false; # restrict CLI user-creation
              results_per_page = 50;
            };
            server.address = "0.0.0.0:${toString servicePort}";
          };
        };

        programs.firefox = {
          enable = true;
          # librewolf allows installations of unsigned extensions
          package = pkgs.wrapFirefox pkgs.librewolf-unwrapped {
            nixExtensions = [
              (
                let
                  # specified in manifest.json of the addon
                  extid = "{f0bca7ce-0cda-41dc-9ea8-126a50fed280}";
                in
                pkgs.runCommand "omnom" { passthru = { inherit extid; }; } ''
                  mkdir -p $out
                  cp ${pkgs.omnom}/share/addons/omnom_ext_firefox.zip $out/${extid}.xpi
                ''
              )
            ];
          };
        };

        environment.systemPackages = [ pkgs.xdotool ];
      };
  };

  testScript =
    # python
    ''
      import re

      def open_omnom():
        # Add-ons Manager
        server.succeed("xdotool mousemove --sync 960 90 click 1")
        server.sleep(10)
        # omnom
        server.succeed("xdotool mousemove --sync 700 190 click 1")
        server.sleep(10)


      service_url = "http://127.0.0.1:${toString servicePort}"

      server.start()
      server.wait_for_unit("omnom.service")
      server.wait_for_open_port(${toString servicePort})
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
      server.succeed("xdotool mousemove --sync 700 350 click 1")
      server.succeed(f"xdotool type {token}")
      server.sleep(10)

      # url
      server.succeed("xdotool mousemove --sync 700 470 click 1")
      server.succeed(f"xdotool type '{service_url}'")
      server.sleep(10)

      # submit
      server.succeed("xdotool mousemove --sync 900 520 click 1")
      server.sleep(10)

      open_omnom()

      # save
      server.succeed("xdotool mousemove --sync 900 520 click 1")
      server.sleep(10)

      # refresh
      server.succeed("xdotool mousemove --sync 100 80 click 1")
      server.sleep(10)

      server.screenshot("home.png")

      # view bookmarks
      server.succeed("xdotool mousemove --sync 300 130 click 1")
      server.sleep(10)

      # view snapshot
      server.succeed("xdotool mousemove --sync 970 230 click 1")
      server.sleep(10)
      server.succeed("xdotool mousemove --sync 160 340 click 1")
      server.sleep(10)

      server.screenshot("screenshot.png")

      # view details
      server.succeed("xdotool mousemove --sync 290 200 click 1")
      server.sleep(10)

      server.screenshot("snapshot_details.png")
    '';
}
