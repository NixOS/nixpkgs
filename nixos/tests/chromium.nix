{
  lib,
  pkgs,
  chromiumPackage,
  ...
}:

{
  inherit (chromiumPackage) name;

  meta = {
    inherit (chromiumPackage.meta) maintainers;
  }
  // lib.optionalAttrs (chromiumPackage.meta ? timeout) {
    # https://github.com/NixOS/hydra/issues/591#issuecomment-435125621
    inherit (chromiumPackage.meta) timeout;
  };

  containers.machine =
    { config, ... }:

    {
      imports = [
        ./common/user-account.nix
        ./common/x11.nix
      ];

      programs.chromium = {
        enable = true;
        extraOptsRecommended = {
          # Set policy for Memory Saver, so we don't race against a
          # "Make Chromium faster" in-product help promo (pop-up):
          HighEfficiencyModeEnabled = false;
        };
      };

      # chromium refuses to run as root user
      test-support.displayManager.auto.user = "alice";
      environment.variables."XAUTHORITY" = "${config.users.users.alice.home}/.Xauthority";

      environment.systemPackages = [
        chromiumPackage
        pkgs.xclip
      ];
    };

  testScript = ''
    machine.wait_for_x()

    with subtest("file:///"):
        machine.execute("runuser alice chromium file:/// >&2 &")
        machine.wait_for_window("Index of /")
        machine.screenshot("file")

    with subtest("chrome://newtab"):
        machine.send_key("ctrl-t")
        machine.wait_for_window("New Tab")
        machine.screenshot("newtab")

    with subtest("chrome://version"):
        machine.send_key("ctrl-l")
        machine.send_chars("chrome://version\n")
        machine.wait_for_window("About Version")
        machine.screenshot("version")

        machine.send_key("tab")
        machine.send_key("spc")
        clipboard = machine.succeed("xclip -out")
        t.assertIn("${chromiumPackage.version}", clipboard)

    with subtest("chrome://sandbox"):
        machine.send_key("ctrl-t")
        machine.send_chars("chrome://sandbox\n")
        machine.wait_for_window("Sandbox Status")
        machine.screenshot("sandbox")

        machine.send_key("ctrl-a")
        machine.send_key("ctrl-c")
        clipboard = machine.succeed("xclip -out")
        t.assertIn("You are adequately sandboxed.", clipboard)
  '';
}
