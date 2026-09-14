{ lib, ... }:

let
  tcpPorts = [
    48084
    48089
    48110
  ];
  udpPorts = [
    5353
    48098
    48099
    48100
  ];
in
{
  name = "moonshine";
  meta.maintainers = with lib.maintainers; [
    neobrain
    anish
    philocalyst
  ];

  nodes.machine =
    { pkgs, ... }:
    let
      server = pkgs.writeShellApplication {
        name = "moonshine";
        runtimeInputs = [ pkgs.coreutils ];
        text = ''
          test "$#" -eq 1
          test "''${XDG_RUNTIME_DIR-}" = /run/user/1000
          test "''${DBUS_SESSION_BUS_ADDRESS-}" = unix:path=/run/user/1000/bus
          test "''${MOONSHINE_LOG-}" = moonshine=debug
          test "''${MOONSHINE_TEST-}" = present
          command -v hello
          grep -F 'title = "Test"' "$1"
          touch /run/user/1000/moonshine-test-ready
          exec sleep infinity
        '';
      };
      package = pkgs.symlinkJoin {
        name = "moonshine-test";
        paths = [
          server
          (pkgs.writeTextDir "share/vulkan/implicit_layer.d/VkLayer_moonshine_wsi.json" "{}")
        ];
        meta.mainProgram = "moonshine";
      };
    in
    {
      services.moonshine = {
        enable = true;
        inherit package;
        user = "alice";
        openFirewall = true;
        firewallInterfaces = [ "eth0" ];
        logFilter = "moonshine=debug";
        extraPackages = [ pkgs.hello ];
        environment.MOONSHINE_TEST = "present";
        settings = {
          application = [
            {
              title = "Test";
              command = [ "true" ];
            }
          ];
          webserver = {
            port = 48089;
            port_https = 48084;
          };
          stream = {
            port = 48110;
            video.port = 48098;
            control.port = 48099;
            audio.port = 48100;
          };
        };
      };

      users.users.alice = {
        isNormalUser = true;
        uid = 1000;
      };
    };

  testScript =
    { nodes, ... }:
    assert nodes.machine.networking.firewall.allowedTCPPorts == tcpPorts;
    assert nodes.machine.networking.firewall.allowedUDPPorts == udpPorts;
    assert nodes.machine.networking.firewall.interfaces.eth0.allowedTCPPorts == tcpPorts;
    assert nodes.machine.networking.firewall.interfaces.eth0.allowedUDPPorts == udpPorts;
    ''
      start_all()
      machine.wait_for_unit("moonshine.service")
      machine.wait_for_file("/run/user/1000/moonshine-test-ready")
      machine.succeed("loginctl show-user alice -p Linger --value | grep -Fx yes")
      machine.succeed("systemctl show moonshine -p SupplementaryGroups --value | grep -Fw moonshine")
      machine.succeed("test -f /run/opengl-driver/share/vulkan/implicit_layer.d/VkLayer_moonshine_wsi.json")
    '';
}
