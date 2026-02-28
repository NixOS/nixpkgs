{
  lib,
  pkgs,
  ...
}:

{
  name = "Repath Studio";

  nodes = {
    machine =
      { pkgs, ... }:
      {
        imports = [
          # enable graphical session + users (alice, bob)
          ./common/x11.nix
          ./common/user-account.nix
        ];

        services.xserver.enable = true;
        test-support.displayManager.auto.user = "alice";

        environment.systemPackages = with pkgs; [
          xdotool
          repath-studio
        ];

        # electron application, give more memory
        virtualisation.memorySize = 4096;
      };
  };

  enableOCR = true;

  # Debug interactively with:
  # - nix run .#nixosTests.repath-studio.driverInteractive -L
  # - start_all()/run_tests()
  # ssh -o User=root vsock%3 (can also do vsock/3, but % works with scp etc.)
  interactive.sshBackdoor.enable = true;

  testScript = /* python */ ''
    start_all()

    machine.wait_for_x()
    machine.succeed("env DISPLAY=:0 sudo -u alice repath-studio &> /tmp/repath.log &")
    machine.wait_for_text(r"(Welcome|Repath|Studio)") # initial telemetry prompt

    machine.screenshot("Repath-Studio-GUI-Welcome")
    machine.send_key("kp_enter") # OK

    # sleep is required it needs time to dismiss the dialog
    machine.sleep(2)
    machine.send_key("ctrl-shift-s")
    machine.sleep(2)
    machine.send_chars("/tmp/saved.rps\n")
    machine.sleep(2)
    print(machine.succeed("cat /tmp/saved.rps"))
    assert "${pkgs.repath-studio.version}" in machine.succeed("cat /tmp/saved.rps")

    machine.screenshot("Repath-Studio-GUI")
  '';

  meta.maintainers = lib.teams.ngi.members;
}
