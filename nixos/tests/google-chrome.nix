{
  pkgs,
  ...
}:

{
  name = "google-chrome";

  meta = {
    inherit (pkgs.google-chrome.meta) maintainers;
    timeout = 600;
  };

  containers.machine =
    { config, ... }:

    {
      imports = [
        ./common/user-account.nix
        ./common/x11.nix
      ];

      programs.google-chrome = {
        enable = true;
        policies = {
          # Set policy for Memory Saver, so we don't race against a
          # "Make Chrome faster" in-product help promo (pop-up):
          HighEfficiencyModeEnabled = false;
          # Don't prompt to sign in, set as default browser, or send telemetry.
          BrowserSignin = 0;
          DefaultBrowserSettingEnabled = false;
          MetricsReportingEnabled = false;
        };
      };

      # Chrome refuses to run as root user
      test-support.displayManager.auto.user = "alice";
      environment.variables."XAUTHORITY" = "${config.users.users.alice.home}/.Xauthority";

      environment.systemPackages = [
        pkgs.xclip
      ];
    };

  testScript = ''
    machine.wait_for_x()

    with subtest("file:///"):
        machine.execute("runuser alice google-chrome file:/// >&2 &")

        # Accept the terms of service
        machine.wait_for_window("Google Chrome and ChromeOS Additional Terms of Service")
        machine.send_key("ret")

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
        t.assertIn("${pkgs.google-chrome.version}", clipboard)

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
