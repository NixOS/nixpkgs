{
  ...
}:

let
  ports = {
    ap-mock = 8003;
    client = 8002;
    opmode = 8001;
    server = 3000;
  };
in

{
  name = "0WM server + client";

  nodes = {
    machine =
      {
        lib,
        pkgs,
        ...
      }:
      {
        imports = [
          {
            programs.zwm-client = {
              enable = true;
            };
          }
          {
            services.zwm-server = {
              enable = true;
              openFirewall = true;
              settings = {
                port = ports.server;
                aps = [ "http://127.0.0.1:${toString ports.ap-mock}" ];
                ssids = [ "Production" ];
              };
            };
          }

          # enable graphical session + users (alice, bob)
          ../tests/common/x11.nix
          ../tests/common/user-account.nix
        ];

        services.xserver.enable = true;
        test-support.displayManager.auto.user = "alice";

        programs.chromium.enable = true;
        programs.chromium.extensions = [
          "cgffilbpcibhmcfbgggfhfolhkfbhmik" # Immersive Web Emulator (XR)
          "lfhmikememgdcahcdlaciloancbhjino" # CORS Unblock
        ];

        environment.systemPackages = with pkgs; [
          chromium
          xdotool # automate clicks
        ];

        # browser requires more memory
        virtualisation.memorySize = 4096;
      };
  };

  enableOCR = true;

  testScript =
    { nodes, ... }:
    let
      user = nodes.machine.users.users.alice;
      bus = "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/${toString user.uid}/bus";
    in
    # python
    ''
      def click_position(x: int, y: int):
        machine.succeed(f"su - alice -c 'DISPLAY=:0 ${bus} xdotool mousemove --sync {x} {y} click 1'")
        machine.sleep(1)

      def click_start():
        machine.wait_for_text(r"(Click|here|start)")
        click_position(513, 467)

      start_all()

      machine.wait_for_unit("zwm-server.service")

      machine.succeed("mkdir -p /logs")

      machine.succeed("0wm-client &> /logs/client.log &")
      machine.succeed("0wm-opmode &> /logs/opmode.log &")
      machine.succeed("0wm-ap-mock &> /logs/ap-mock.log &")

      machine.wait_for_x()

      # open browser
      machine.succeed("su - alice -c 'DISPLAY=:0 ${bus} chromium http://127.0.0.1:${toString ports.client} >&2 &'")

      click_start()

      # allow location permissions
      machine.wait_for_text(r"(Allow|visiting|site|this time|location)")
      click_position(294, 229)

      # start scan
      machine.sleep(5)
      click_position(982, 450)

      msg = '\"GET /cgi-bin/scan/radio0 HTTP/1.1\" 200'
      machine.wait_until_succeeds(f"grep -q {msg} /logs/ap-mock.log")
    '';

  # Debug interactively with:
  # - nix run -f . nixosTests._0wm.driverInteractive -L
  # - run_tests()
  interactive.sshBackdoor.enable = true; # ssh -o User=root vsock/3
  interactive.nodes = {
    machine =
      { lib, ... }:
      {
        # forward ports from VM to host
        virtualisation.forwardPorts = map (port: {
          from = "host";
          host.port = port;
          guest.port = port;
        }) (lib.attrValues ports);

        # forwarded ports need to be accessible
        networking.firewall.enable = false;

        # make ports reachable on host and VM
        environment.variables = lib.genAttrs [
          "CLIENT_ADDRESS"
          "OP_MODE_ADDRESS"
          "AP_MOCK_ADDRESS"
        ] (_: "0.0.0.0");
      };
  };
}
