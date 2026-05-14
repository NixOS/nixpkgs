{ lib, hostPkgs, ... }:
let
  port = 8080;
  server = "http://server:${toString port}";
in
{
  name = "stirling-pdf";
  meta = {
    maintainers = with lib.maintainers; [
      timhae
      phanirithvij
    ];
  };

  enableOCR = true;
  globalTimeout = 600;
  nodes = {
    server =
      { config, pkgs, ... }:
      {
        services.stirling-pdf = {
          enable = true;
          package = pkgs.stirling-pdf;
          environment = {
            SERVER_PORT = port;
            DISABLE_ADDITIONAL_FEATURES = false;
            SECURITY_ENABLELOGIN = true;
          };
        };
        networking.firewall.allowedTCPPorts = [ port ];
      };
    client =
      { config, pkgs, ... }:
      {
        virtualisation = {
          memorySize = 4096;
          cores = 4;
          qemu.options = [
            # Force qemu at 640x480 resolution
            "-vga none -device virtio-gpu-pci,xres=640,yres=480"
          ];
        };
        imports = [ ./common/wayland-cage.nix ];
        services.cage.program = lib.getExe pkgs.stirling-pdf-desktop;
        systemd.tmpfiles.settings."stirling-provisioning.json"."/etc/stirling-pdf/stirling-provisioning.json"."L+".argument =
          builtins.toString (
            pkgs.writeText "stirling-provisioning.json" ''
              {
                "serverUrl": "${server}",
                "lockConnectionMode": true
              }
            ''
          );
        programs.ydotool.enable = true;
        users.users.alice.extraGroups = [ "ydotool" ];
      };
  };

  testScript = ''
    server.start()
    server.wait_for_unit("stirling-pdf.service")
    server.wait_for_console_text("Stirling-PDF Started")

    # initial login
    client.start()
    client.wait_for_text("Sign in to Server")
    client.send_chars("admin", 0.1)
    client.send_key("tab", 1)
    client.send_chars("stirling\n", 0.1)

    # skip telemetry prompt
    client.wait_for_text("analytics")
    client.send_key("shift-tab", 1)
    client.send_key("tab", 1)
    client.send_key("tab", 1)
    client.send_key("kp_enter", 1)

    # update password
    client.wait_for_text("password")
    client.send_key("tab", 1)
    client.send_key("shift-tab", 1)
    client.send_key("shift-tab", 1)
    client.send_key("shift-tab", 1)
    client.send_chars("stirling2", 0.1)
    client.send_key("tab", 1)
    client.send_chars("stirling2", 0.1)
    client.send_key("tab", 1)
    client.send_key("kp_enter", 1)

    # final login
    client.wait_for_text("Sign in to Server")
    client.send_chars("admin", 0.1)
    client.send_key("tab", 1)
    client.send_chars("stirling2\n", 0.1)
    client.wait_for_text("Welcome to Stirling")
    client.send_key("kp_enter", 1)

    # version prompt
    client.wait_for_text("Config")
    client.execute("ydotool mousemove -a -- 290 220") # Config button
    client.execute("ydotool click 0xC0")
    client.wait_for_text("Current Frontend Version")
    client.screenshot("stirling-pdf-version")
  '';

  # Debug interactively with:
  # - nix-build -A nixosTests.stirling-pdf-desktop.driverInteractive
  # - ./result/bin/nixos-test-driver
  # - run_tests()
  # ssh -o User=root vsock%3 (can also do vsock/3, but % works with scp etc.)
  interactive.sshBackdoor.enable = true;
  interactive.nodes.client =
    { pkgs, ... }:
    {
      # make the mouse visible
      services.cage.environment.WLR_NO_HARDWARE_CURSORS = "1";
    };
  interactive.nodes.server =
    { ... }:
    {
      virtualisation.forwardPorts = [
        {
          from = "host";
          host.port = port;
          guest.port = port;
        }
      ];
      # forwarded ports need to be accessible
      networking.firewall.allowedTCPPorts = [ port ];
    };
}
