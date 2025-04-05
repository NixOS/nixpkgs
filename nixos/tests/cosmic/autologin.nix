{ pkgs, ... }:

{
  name = "cosmic-autologin";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ thefossguy ];
  };

  nodes.machine =
    { config, ... }:
    {
      imports = [ ./config-base.nix ];

      services.displayManager.autoLogin = {
        enable = true;
        user = config.users.users.alice.name;
      };
    };

  testScript =
    { nodes, ... }:
    let
      user = nodes.machine.users.users.alice;
    in
    ''
      with subtest("cosmic-greeter initialisation"):
          machine.wait_for_unit("graphical.target")
          # _One_ of the final processes to start as part of the
          # `cosmic-session` target is the Workspaces applet. So, wait
          # for it to start. The process existing means that COSMIC
          # now handles any opened windows from now on.
          machine.wait_until_succeeds("pgrep --uid ${toString user.uid} --full 'cosmic-panel-button com.system76.CosmicWorkspaces'")

      # The best way to test for Wayland and XWayland is to launch
      # the GUI applications and see the results yourself.
      with subtest("Launch applications"):
          # key: binary_name
          # value: "app-id" as reported by `lswt`
          gui_apps_to_launch = {}

          # We want to ensure that the first-party applications
          # start/launch properly.
          #gui_apps_to_launch['cosmic-edit'] = 'com.system76.CosmicEdit' # `cosmic-edit` crashes, disable temporarily
          gui_apps_to_launch['cosmic-files'] = 'com.system76.CosmicFiles'
          gui_apps_to_launch['cosmic-player'] = 'com.system76.CosmicPlayer'
          gui_apps_to_launch['cosmic-settings'] = 'com.system76.CosmicSettings'
          gui_apps_to_launch['cosmic-store'] = 'com.system76.CosmicStore'
          gui_apps_to_launch['cosmic-term'] = 'com.system76.CosmicTerm'

          for gui_app in gui_apps_to_launch:
              # Note: $DISPLAY is usually `:0` (**not `:1`**) with autologin
              machine.succeed(f"su - ${user.name} -c 'DISPLAY=:0 {gui_app} >&2 &'", timeout=5)
              # Nix builds the following non-commented expression to the following:
              #                              `su - alice -c 'WAYLAND_DISPLAY=wayland-1 XDG_RUNTIME_DIR=/run/user/1000 lswt --json | jq ".toplevels" | grep "^    \\"app-id\\": \\"{gui_apps_to_launch[gui_app]}\\"$"' `
              machine.wait_until_succeeds(f''''su - ${user.name} -c 'WAYLAND_DISPLAY=wayland-1 XDG_RUNTIME_DIR=/run/user/${toString user.uid} lswt --json | jq ".toplevels" | grep "^    \\"app-id\\": \\"{gui_apps_to_launch[gui_app]}\\"$"' '''', timeout=30)
              machine.succeed(f"pkill {gui_app}", timeout=5)

      machine.shutdown()
    '';
}
