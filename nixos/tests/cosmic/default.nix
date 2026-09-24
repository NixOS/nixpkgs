{
  config,
  lib,
  testName,
  enableAutologin,
  enableXWayland,
  ...
}:

let
  user = config.nodes.machine.users.users.alice;
  logFilePath = "/home/${user.name}/${testName}";
  # Use `writeShellScriptBin` instead of `writeShellScript` so that the
  # process name in the journald log appears as 'cosmicTest[$pid]'
  cosmicTest = config.node.pkgs.writeShellScriptBin "cosmicTest" ''
    exec ${lib.getExe config.node.pkgs.python3Minimal} ${./test-script.py} \
        --log-file-path ${logFilePath} \
        --cosmic-reader-pdf ${config.node.pkgs.empty-pdf} \
        --polkit-agent-helper-path ${config.node.pkgs.polkit.out}/lib/polkit-1/polkit-agent-helper-1 \
        --root-user-password ${user.password}
  '';
  cosmicTestDesktop = config.node.pkgs.makeDesktopItem {
    name = "cosmicTest";
    desktopName = "COSMIC NixOS VM test (${testName})";
    exec = "cosmicTest";
  };
  cosmicTestAutostartItem = config.node.pkgs.makeAutostartItem {
    name = "cosmicTest";
    package = cosmicTestDesktop;
  };
in

{
  name = testName;

  meta.maintainers = lib.teams.cosmic.members;

  nodes.machine = {
    imports = [ ../common/user-account.nix ];

    services = {
      # For `cosmic-store` to be added to `environment.systemPackages`
      # and for it to work correctly because Flatpak is a runtime
      # dependency of `cosmic-store`.
      flatpak.enable = true;

      displayManager.cosmic-greeter.enable = true;
      desktopManager.cosmic = {
        enable = true;
        xwayland.enable = enableXWayland;
      };
    };

    services.displayManager.autoLogin = lib.mkIf enableAutologin {
      enable = true;
      user = user.name;
    };

    users.users = {
      alice.extraGroups = [
        "uinput" # for ydotoold
      ];

      root.password = user.password;
      root.hashedPasswordFile = lib.mkForce null;
    };

    hardware.uinput.enable = true;

    environment.systemPackages = with config.node.pkgs; [
      ydotool
      cosmicTest
      cosmicTestAutostartItem

      # These two packages are used to check if a window was opened
      # under the COSMIC session or not. Kinda important.
      # TODO: Move the check from the test module to
      # `nixos/lib/test-driver/src/test_driver/machine.py` so more
      # Wayland-only testing can be done using the existing testing
      # infrastructure.
      jq
      lswt
    ];

    # So far, all COSMIC tests launch a few GUI applications. In doing
    # so, the default allocated memory to the guest of 1024M quickly
    # poses a very high risk of an OOM-shutdown which is worse than an
    # OOM-kill. Because now, the test failed, but not for a genuine
    # reason, but an OOM-shutdown. That's an inconclusive failure
    # which might possibly mask an actual failure. Not enabling
    # systemd-oomd because we need said applications running for a
    # few seconds. So instead, bump the allocated memory to the guest
    # from 1024M to 4x; 4096M.
    virtualisation.memorySize = 4096;
  };

  testScript =
    { nodes, ... }:
    ''
      #testName: ${testName}
      import sys
    ''
    + (
      if enableAutologin then
        ''
          with subtest("cosmic-greeter initialisation"):
              machine.wait_for_unit("graphical.target", timeout=120)
        ''
      else
        ''
          from time import sleep

          machine.wait_for_unit("graphical.target", timeout=120)
          machine.wait_until_succeeds("pgrep --uid ${config.nodes.machine.users.users.cosmic-greeter.name} --full cosmic-greeter", timeout=30)
          # Sleep for 10 seconds for ensuring that `greetd` loads the
          # password prompt for the login screen properly.
          sleep(10)

          with subtest("cosmic-session login"):
              machine.send_chars("${user.password}\n", delay=0.2)
        ''
    )
    + ''
      with subtest("xdg autostart support in cosmic"):
          # When checking the status of our `cosmicTest` package with:
          # `machine.wait_for_unit("app-cosmicTest@autostart.service", user="${user.name}")`
          # We are immediately greeted with the error:
          # ```
          # subtest: xdg autostart support in cosmic
          # machine: waiting for unit app-cosmicTest@autostart.service with user alice
          # machine # [   26.497516] cosmic-comp[1352]: [EGL] 0x3008 (BAD_DISPLAY) eglCreateSync: _eglCreateSync
          # machine # [   26.511706] su[1416]: Successful su for alice by root
          # machine # [   26.528190] su[1416]: pam_unix(su:session): session opened for user alice(uid=1000) by (uid=0)
          # machine # Failed to connect to user scope bus via local transport: No such file or directory
          # machine # [   26.599563] su[1416]: pam_unix(su:session): session closed for user alice
          # !!! Test "xdg autostart support in cosmic" failed with error: "retrieving systemctl property "ActiveState" for unit "app-cosmicTest@autostart.service" under user "alice" failed with exit code 1"
          # ```
          # Meaning, our session is extremely new and the D-Bus user
          # session socket does not yet exist. Instead, lets poll for
          # the log file that the test is guaranteed to write to, as
          # soon as it starts.
          machine.wait_for_file("${logFilePath}.log", timeout=120)

      exit_code = 0
      try:
          machine.wait_for_file("${logFilePath}.done", timeout=700)
      except Exception:
          exit_code = 1

      # The log file is created in the very beginning of the test
      # script's execution. If we are here, it means that the
      # `wait_for_unit`'s "guard" on the test script's autostart unit
      # plus the 630 second combined timeout of other two
      # `wait_for_file`s, make it extremely likely for the log file to
      # be present.
      machine.copy_from_machine("${logFilePath}.log")

      machine.shutdown()

      with open(f"{machine.out_dir}/${testName}.log") as test_log_file:
          contents = test_log_file.read()
          print(contents)
          if any("Z [ERROR] [L:" in line for line in contents.splitlines()):
              exit_code = 1

      sys.exit(exit_code)
    '';
}
