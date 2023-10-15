import ./make-test-python.nix (
{ pkgs, lib, ...}:
{
  name = "gnome-extensions";
  meta.maintainers = [ lib.maintainers.piegames ];

  nodes.machine =
    { pkgs, ... }:
    {
      imports = [ ./common/user-account.nix ];

      # Install all extensions
      environment.systemPackages = lib.pipe pkgs.gnomeExtensions [
        (lib.filterAttrs (name: _: name != "buildShellExtension")) /* sigh */
        (lib.filterAttrs (name: _: name != "recurseForDerivations")) /* more sigh */
        lib.attrValues
      ];

      # Some extensions are broken, but that's kind of the point of a testing VM
      nixpkgs.config.allowBroken = true;
      # There are some aliases which throw exceptions; ignore them.
      # Also prevent duplicate extensions under different names.
      nixpkgs.config.allowAliases = false;

      # Configure GDM
      services.xserver.enable = true;
      services.xserver.displayManager = {
        gdm = {
          enable = true;
          debug = true;
          wayland = true;
        };
        autoLogin = {
          enable = true;
          user = "alice";
        };
      };

      # Configure Gnome
      services.xserver.desktopManager.gnome.enable = true;
      services.xserver.desktopManager.gnome.debug = true;

      systemd.user.services = {
        "org.gnome.Shell@wayland" = {
          serviceConfig = {
            ExecStart = [
              # Clear the list before overriding it.
              ""
              # Eval API is now internal so Shell needs to run in unsafe mode.
              # TODO: improve test driver so that it supports openqa-like manipulation
              # that would allow us to drop this mess.
              "${pkgs.gnome.gnome-shell}/bin/gnome-shell --unsafe-mode"
            ];
          };
        };
      };

    };

  testScript = { nodes, ... }: let
    # Keep line widths somewhat manageable
    user = nodes.machine.users.users.alice;
    uid = toString user.uid;
    bus = "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/${uid}/bus";
    # Run a command in the appropriate user environment
    run = command: "su - ${user.name} -c '${bus} ${command}'";

    # Call javascript in gnome shell, returns a tuple (success, output), where
    # `success` is true if the dbus call was successful and output is what the
    # javascript evaluates to.
    eval = command: run "gdbus call --session -d org.gnome.Shell -o /org/gnome/Shell -m org.gnome.Shell.Eval ${command}";

    # False when startup is done
    startingUp = eval "Main.layoutManager._startingUp";

    # Extensions to keep always enabled together
    alwaysOnExtensions = map (name: pkgs.gnomeExtensions.${name}.extensionUuid) [
      "applications-menu"
      "user-themes"
    ];

    # Extensions to enable and disable individually
    testExtensions = map (name: pkgs.gnomeExtensions.${name}.extensionUuid) [
      "appindicator"
      "dash-to-dock"
      "dash-to-panel"
      "ddterm"
      "emoji-selector"
      "gsconnect"
      "system-monitor"
      "desktop-icons-ng-ding"
      "workspace-indicator"
      "vitals"
    ];

    # Don't mind the indentation, this is what you get for code-generating a whitespace sensitive lanugage …
    checkState = target: extension: ''
      state = machine.succeed(
                  "${run "gnome-extensions info ${extension}"} | grep '^  State: .*$'"
              )
              assert "${target}" in state, f"{state} instead of ${target}"
    '';
    checkExtension = disable: extension: ''
      with subtest("Enable extension '${extension}'"):
          # Check that the extension is properly initialized; skip out of date ones
          state = machine.succeed(
              "${run "gnome-extensions info ${extension}"} | grep '^  State: .*$'"
          )
          if "OUT OF DATE" in state:
              machine.log("Extension ${extension} will be skipped because out of date")
          else:
              assert "INITIALIZED" in state, f"{state} instead of INITIALIZED"

              # Enable and optionally disable

              machine.succeed("${run "gnome-extensions enable ${extension}"}")
              ${checkState "ENABLED" "${extension}"}

              ${lib.optionalString disable ''
                machine.succeed("${run "gnome-extensions disable ${extension}"}")
                        ${checkState "DISABLED" "${extension}"}
              ''}
    '';
  in
  ''
    with subtest("Login to GNOME with GDM"):
        # wait for gdm to start
        machine.wait_for_unit("display-manager.service")
        # wait for the wayland server
        machine.wait_for_file("/run/user/${uid}/wayland-0")
        # wait for alice to be logged in
        machine.wait_for_unit("default.target", "${user.name}")
        # check that logging in has given the user ownership of devices
        assert "alice" in machine.succeed("getfacl -p /dev/snd/timer")

    with subtest("Wait for GNOME Shell"):
        # correct output should be (true, 'false')
        machine.wait_until_succeeds(
            "${startingUp} | grep -q 'true,..false'"
        )

        # Close the Activities view so that Shell can correctly track the focused window.
        machine.send_key("esc")
        # # Disable extension version validation (only use for manual testing)
        # machine.succeed(
        #   "${run "gsettings set org.gnome.shell disable-extension-version-validation true"}"
        # )
    ''
    + lib.concatMapStrings (checkExtension false) alwaysOnExtensions
    + lib.concatMapStrings (checkExtension true) testExtensions
  ;
}
)
