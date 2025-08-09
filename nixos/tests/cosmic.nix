{
  config,
  lib,
  testName,
  enableAutologin,
  enableXWayland,
  ...
}:

{
  name = testName;

  meta.maintainers = lib.teams.cosmic.members;

  nodes.machine = {
    imports = [ ./common/user-account.nix ];

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
      user = "alice";
    };

    environment.systemPackages = with config.node.pkgs; [
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
    let
      cfg = nodes.machine;
      user = cfg.users.users.alice;
      DISPLAY = lib.strings.optionalString enableXWayland (
        if enableAutologin then "DISPLAY=:0" else "DISPLAY=:1"
      );
    in
    ''
      #testName: ${testName}
    ''
    + (
      if (enableAutologin) then
        ''
          with subtest("cosmic-greeter initialisation"):
              machine.wait_for_unit("graphical.target", timeout=120)
        ''
      else
        ''
          from time import sleep

          machine.wait_for_unit("graphical.target", timeout=120)
          machine.wait_until_succeeds("pgrep --uid ${toString cfg.users.users.cosmic-greeter.name} --full cosmic-greeter", timeout=30)
          # Sleep for 10 seconds for ensuring that `greetd` loads the
          # password prompt for the login screen properly.
          sleep(10)

          with subtest("cosmic-session login"):
              machine.send_chars("${user.password}\n", delay=0.2)
        ''
    )
    + ''
          # _One_ of the final processes to start as part of the
          # `cosmic-session` target is the Workspaces applet. So, wait
          # for it to start. The process existing means that COSMIC
          # now handles any opened windows from now on.
          machine.wait_until_succeeds("pgrep --uid ${toString user.uid} --full 'cosmic-panel-button com.system76.CosmicWorkspaces'", timeout=30)

      # The best way to test for Wayland and XWayland is to launch
      # the GUI applications and see the results yourself.
      with subtest("Launch applications"):
          # key: binary_name
          # value: "app-id" as reported by `lswt`
          gui_apps_to_launch = {}

          # We want to ensure that the first-party applications
          # start/launch properly.
          gui_apps_to_launch['cosmic-edit'] = 'com.system76.CosmicEdit'
          gui_apps_to_launch['cosmic-files'] = 'com.system76.CosmicFiles'
          gui_apps_to_launch['cosmic-player'] = 'com.system76.CosmicPlayer'
          gui_apps_to_launch['cosmic-settings'] = 'com.system76.CosmicSettings'
          gui_apps_to_launch['cosmic-store'] = 'com.system76.CosmicStore'
          gui_apps_to_launch['cosmic-term'] = 'com.system76.CosmicTerm'

          for gui_app, app_id in gui_apps_to_launch.items():
              # Don't fail the test if binary is absent
              if machine.execute(f"su - ${user.name} -c 'command -v {gui_app}'", timeout=5)[0] == 0:
                  machine.succeed(f"su - ${user.name} -c 'WAYLAND_DISPLAY=wayland-1 XDG_RUNTIME_DIR=/run/user/${toString user.uid} ${DISPLAY} {gui_app} >&2 &'", timeout=5)
                  # Nix builds the following non-commented expression to the following:
                  #                              `su - alice -c 'WAYLAND_DISPLAY=wayland-1 XDG_RUNTIME_DIR=/run/user/1000 lswt --json | jq ".toplevels" | grep "^    \\"app-id\\": \\"{app_id}\\"$"' `
                  machine.wait_until_succeeds(f''''su - ${user.name} -c 'WAYLAND_DISPLAY=wayland-1 XDG_RUNTIME_DIR=/run/user/${toString user.uid} lswt --json | jq ".toplevels" | grep "^    \\"app-id\\": \\"{app_id}\\"$"' '''', timeout=30)
                  machine.succeed(f"pkill {gui_app}", timeout=5)

      machine.succeed("echo 'test completed succeessfully' > /${testName}", timeout=5)
      machine.copy_from_vm('/${testName}')

      machine.shutdown()
    '';
}
