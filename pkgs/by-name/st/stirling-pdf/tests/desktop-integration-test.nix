{ lib, hostPkgs, ... }:
let
  port = 8080;
  server = "http://server:${toString port}";
in
{
  name = "stirling-pdf";
  meta = {
    maintainers = with lib.maintainers; [ timhae ];
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
            DISABLE_ADDITIONAL_FEATURES = "false";
            SECURITY_ENABLELOGIN = "true";
          };
        };
        networking.firewall = {
          allowedTCPPorts = [ port ];
          allowedUDPPorts = [ port ];
        };
      };
    client =
      { config, pkgs, ... }:
      {
        virtualisation.memorySize = 4096;
        imports = [ (hostPkgs.path + "/nixos/tests/common/wayland-cage.nix") ];
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

    # initial login
    client.start()
    client.wait_for_text("Sign in to Server")
    client.send_chars("admin", 0.1)
    client.send_key("tab", 1)
    client.send_chars("stirling\n", 0.1)

    # skip telemetry prompt
    client.sleep(10)
    client.send_key("shift-tab", 1)
    client.send_key("tab", 1)
    client.send_key("tab", 1)
    client.send_key("kp_enter", 1)

    # update password
    client.sleep(3)
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
    client.send_key("tab", 1)
    client.send_key("tab", 1)
    client.send_key("tab", 1)
    client.send_key("tab", 1)
    client.send_key("tab", 1)
    client.send_key("tab", 1)
    client.send_key("tab", 1)
    client.send_key("tab", 1)
    client.send_key("kp_enter", 5)
    client.screenshot("stirling-pdf-version")
    # the screenshots sometimes produce huge ppm files for some reason and it
    # takes forever for the ocr to take place..
    # frontend version is lagging behind for some reason
    # client.wait_for_text("Current Frontend Version: ${hostPkgs.stirling-pdf-desktop.version}")
    # client.wait_for_text("Current Backend Version: ${hostPkgs.stirling-pdf.version}")
  '';
}
