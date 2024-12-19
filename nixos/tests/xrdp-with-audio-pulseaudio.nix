import ./make-test-python.nix (
  { pkgs, ... }:
  {
    # How to interactively test this module if the audio actually works

    # - nix run .#pulseaudio-module-xrdp.tests.xrdp-with-audio-pulseaudio.driverInteractive
    # - test_script() # launches the terminal and the tests itself
    # - server.send_monitor_command("hostfwd_add tcp::3389-:3389") # forward the RDP port to the host
    # - Connect with the RDP client you like (ex: Remmina)
    # - Don't forget to enable audio support. In remmina: Advanced -> Audio output mode to Local (default is Off)
    # - Open a browser or something that plays sound. Ex: chromium

    name = "xrdp-with-audio-pulseaudio";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ lucasew ];
    };

    nodes = {
      server =
        { pkgs, ... }:
        {
          imports = [ ./common/user-account.nix ];

          environment.etc."xrdp/test.txt".text = "Shouldn't conflict";

          services.xrdp.enable = true;
          services.xrdp.audio.enable = true;
          services.xrdp.defaultWindowManager = "${pkgs.xterm}/bin/xterm";

          hardware.pulseaudio = {
            enable = true;
          };

          systemd.user.services.pactl-list = {
            script = ''
              while [ ! -S /tmp/.xrdp/xrdp_chansrv_audio_in_socket_* ]; do
                sleep 1
              done
              sleep 1
              ${pkgs.pulseaudio}/bin/pactl list
              echo Source:
              ${pkgs.pulseaudio}/bin/pactl get-default-source | tee /tmp/pulseaudio-source
              echo Sink:
              ${pkgs.pulseaudio}/bin/pactl get-default-sink | tee /tmp/pulseaudio-sink

            '';
            wantedBy = [ "default.target" ];
          };

          networking.firewall.allowedTCPPorts = [ 3389 ];
        };

      client =
        { pkgs, ... }:
        {
          imports = [
            ./common/x11.nix
            ./common/user-account.nix
          ];
          test-support.displayManager.auto.user = "alice";

          environment.systemPackages = [ pkgs.freerdp ];

          services.xrdp.enable = true;
          services.xrdp.audio.enable = true;
          services.xrdp.defaultWindowManager = "${pkgs.icewm}/bin/icewm";

          hardware.pulseaudio = {
            enable = true;
          };
        };
    };

    testScript =
      { nodes, ... }:
      let
        user = nodes.client.config.users.users.alice;
      in
      ''
        start_all()

        client.wait_for_x()
        client.wait_for_file("${user.home}/.Xauthority")
        client.succeed("xauth merge ${user.home}/.Xauthority")

        client.sleep(5)

        client.execute("xterm >&2 &")
        client.sleep(1)

        client.send_chars("xfreerdp /cert-tofu /w:640 /h:480 /v:127.0.0.1 /u:${user.name} /p:${user.password} /sound\n")

        client.sleep(10)

        client.succeed("[ -S /tmp/.xrdp/xrdp_chansrv_audio_in_socket_* ]") # checks if it's a socket
        client.sleep(5)
        client.screenshot("localrdp")

        client.execute("xterm >&2 &")
        client.sleep(1)
        client.send_chars("xfreerdp /cert-tofu /w:640 /h:480 /v:server /u:${user.name} /p:${user.password} /sound\n")
        client.sleep(10)

        server.succeed("[ -S /tmp/.xrdp/xrdp_chansrv_audio_in_socket_* ]") # checks if it's a socket
        server.succeed('[ "$(cat /tmp/pulseaudio-source)" == "xrdp-source" ]')
        server.succeed('[ "$(cat /tmp/pulseaudio-sink)" == "xrdp-sink" ]')
        client.screenshot("remoterdp")
      '';
  }
)
