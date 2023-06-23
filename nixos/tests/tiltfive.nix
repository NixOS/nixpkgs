import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "tiltfive";
  meta.maintainers = with lib.maintainers; [ q3k ];

  nodes.machine = { nodes, ... }:
    let user = nodes.machine.users.users.alice;
    in {
      imports = [ ./common/user-account.nix ./common/x11.nix ];

      hardware.tiltfive.enable = true;
      nixpkgs.config.allowUnfree = true;

      test-support.displayManager.auto.user = user.name;
      environment.systemPackages = [ pkgs.xdotool ];
    };

  enableOCR = true;

  testScript = { nodes, ... }:
    let user = nodes.machine.users.users.alice;
    in ''
      machine.wait_for_x()
      machine.wait_for_file("${user.home}/.Xauthority")
      machine.succeed("xauth merge ${user.home}/.Xauthority")

      # Start the control panel without the service running and expect error
      # message. This ensures that this test exercises connectivity between the
      # service and the control panel.
      machine.execute("systemctl stop tiltfive")

      machine.execute("su - alice -c tiltfive-control-panel >&2 &")
      machine.wait_for_text("Service disconnected")
      machine.screenshot("controlpanel1")

      # Now start the service and expect the wizard to start up.
      machine.execute("systemctl start tiltfive")
      machine.wait_for_text("Gameboard not set")
      machine.screenshot("controlpanel2")

      # This is is the best we can do without emulating Tilt Five glasses :).
    '';
})
