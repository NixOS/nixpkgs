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

        # electron application, give more memory and cpu
        virtualisation.memorySize = 4096;
        virtualisation.cores = 4;
        virtualisation.qemu.options = [
          # Force qemu at 1020x768 resolution for the Save button click
          "-vga none -device virtio-gpu-pci,xres=1020,yres=768"
        ];
      };
  };

  enableOCR = true;

  # Debug interactively with:
  # - nix run .#nixosTests.repath-studio.driverInteractive -L
  # - start_all()/run_tests()
  interactive.sshBackdoor.enable = true;

  testScript = /* python */ ''
    start_all()

    machine.wait_for_x()
    machine.succeed("env DISPLAY=:0 sudo -u alice repath-studio &> /tmp/repath.log &")
    machine.wait_for_text(r"(Welcome|Repath|Studio)") # initial telemetry prompt

    machine.screenshot("Repath-Studio-GUI-Welcome")
    machine.send_key("kp_enter") # OK

    # move the mouse to the "Save" icon on the toolbar
    machine.execute("su - alice -c \"DISPLAY=:0 xdotool mousemove --sync 95 65\"")

    # click the save icon until the GTK save dialog appears
    for _ in range(30):
        status, _ = machine.execute("su - alice -c \"DISPLAY=:0 xdotool search --name 'Save File'\"")
        if status == 0:
            break
        machine.execute("su - alice -c \"DISPLAY=:0 xdotool click 1\"")
        machine.sleep(1)

    # wait for the GTK dialog to focus the text input field
    machine.sleep(3)
    machine.send_chars("saved.rps") # avoid using absolute path here, doesn't work for some reason
    # wait for text to be typed
    machine.sleep(2)

    machine.execute("su - alice -c \"DISPLAY=:0 xdotool key alt+s\"") # save file
    machine.wait_until_succeeds("ls /home/alice/saved.rps")

    machine.succeed("cat /home/alice/saved.rps")
    assert "${pkgs.repath-studio.version}" in machine.succeed("cat /home/alice/saved.rps")

    machine.screenshot("Repath-Studio-GUI")
  '';

  meta.maintainers = lib.teams.ngi.members;
}
