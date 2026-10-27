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
        virtualisation.memorySize = 4096;
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
            # The v3 onboarding dialog needs a larger display.
            "-vga none -device virtio-gpu-pci,xres=1280,yres=800"
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
      };
  };

  testScript = ''
    server.start()
    server.wait_for_unit("stirling-pdf.service")
    server.wait_for_console_text("Stirling-PDF Started")

    # Complete the desktop onboarding and sign in to the provisioned server.
    client.start()
    client.wait_for_text("Step")
    client.send_key("kp_enter", 1)
    client.wait_for_text("Step2of2")
    client.send_chars("admin", 0.1)
    client.send_key("tab", 1)
    client.send_chars("stirling\n", 0.1)
    client.wait_for_console_text("Auth token saved to keyring")
    client.sleep(2)
    client.screenshot("stirling-pdf-desktop")
  '';

  # Debug interactively with:
  # - nix-build -A nixosTests.stirling-pdf-desktop.driverInteractive
  # - ./result/bin/nixos-test-driver
  # - run_tests()
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
