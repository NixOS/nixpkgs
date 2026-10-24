# AeroThemePlasma "currently lacks full Wayland support", so test X11
{ pkgs, ... }:

let
  evalModule =
    {
      enable,
      plasma ? false,
    }:
    import ../lib/eval-config.nix {
      system = null;
      modules = [
        {
          boot.isContainer = true;
          nixpkgs.config.allowUnfree = true;
          nixpkgs.hostPlatform = "x86_64-linux";
          system.stateVersion = "26.05";
          programs.aerothemeplasma.enable = enable;
          services.desktopManager.plasma6.enable = plasma;
        }
      ];
    };

  evaluates = args: (builtins.tryEval (evalModule args).config.system.build.toplevel.drvPath).success;

  common =
    { ... }:
    {
      imports = [ ./common/user-account.nix ];
      nixpkgs.config.allowUnfree = true;
      virtualisation.memorySize = 2047;
      services.xserver.enable = true;
      services.displayManager.sddm.enable = true;
      services.desktopManager.plasma6.enable = true;
      programs.aerothemeplasma.enable = true;
    };

  autoLogin = session: {
    services.displayManager.defaultSession = session;
    services.displayManager.autoLogin = {
      enable = true;
      user = "alice";
    };
  };
in
assert evaluates { enable = false; };
assert !(evaluates { enable = true; });
assert evaluates {
  enable = true;
  plasma = true;
};
{
  name = "aerothemeplasma";
  meta = {
    maintainers = [ pkgs.lib.maintainers.aaravrav ];
    # Hydra cannot build unfree assets, so disable this test there
    hydraPlatforms = [ ];
  };

  enableOCR = true;

  node.pkgsReadOnly = false;

  nodes.machine =
    { ... }:
    {
      imports = [
        common
        (autoLogin "aerothemeplasmax11")
      ];
      users.users.alice.extraGroups = [ "wheel" ];
    };

  nodes.stock =
    { ... }:
    {
      imports = [
        common
        (autoLogin "plasmax11")
      ];
      programs.aerothemeplasma = {
        assets.enable = false;
        kwinComponents.enable = false;
        sddm.enable = false;
      };
    };

  # SDDM login automation is flaky, so test only the greeter
  nodes.greeter =
    { ... }:
    {
      imports = [ common ];
      services.displayManager.defaultSession = "plasmax11";
      programs.aerothemeplasma.uacAgent.enable = false;
    };

  testScript =
    { nodes, ... }:
    let
      aeroPackage = pkgs.kdePackages.aerothemeplasmaPackages.aerothemeplasma;
      aeroTheme = "${aeroPackage}/share/sddm/themes/sddm-theme-mod";
      mismatchedLibplasma = pkgs.kdePackages.aerothemeplasma-libplasma.override {
        libplasma = pkgs.kdePackages.libplasma.overrideAttrs {
          version = "0";
          __intentionallyOverridingVersion = true;
        };
      };
      forkLibplasma = pkgs.kdePackages.aerothemeplasma-libplasma;
      uacAgent = pkgs.kdePackages.aeroshell-uac-polkit-agent;
      user = nodes.machine.users.users.alice;
    in
    assert !forkLibplasma.meta.broken;
    assert mismatchedLibplasma.meta.broken;
    assert builtins.hasAttr "plasma-polkit-agent" nodes.stock.systemd.user.services;
    assert !(builtins.hasAttr "plasma-polkit-agent" nodes.greeter.systemd.user.services);
    ''
      def wait_for_shell(m):
          m.wait_for_file("/run/user/1000/xauth_*")
          m.wait_until_succeeds("test -s /run/user/1000/xauth_*")
          m.succeed("xauth merge /run/user/1000/xauth_*")
          m.succeed("su - ${user.name} -c 'xauth merge /run/user/1000/xauth_*'")
          m.wait_until_succeeds("pgrep plasmashell")
          m.wait_for_window("^Desktop ")

      start_all()

      with subtest("Wait for the AeroThemePlasma session"):
          wait_for_shell(machine)

      with subtest("Check plasmashell started with the AeroThemePlasma shell"):
          machine.succeed(
              "grep -z PLASMA_DEFAULT_SHELL=io.gitgud.wackyideas.desktop /proc/$(pgrep -o plasmashell)/environ"
          )

      with subtest("Check plasmashell loaded the forked libplasma"):
          machine.succeed(
              "grep -qF '${forkLibplasma}' /proc/$(pgrep -o plasmashell)/maps"
          )

      with subtest("Check packaged components and assets"):
          machine.succeed(
              "test -x '${aeroPackage}/bin/startatp-wayland'",
              "test -x '${aeroPackage}/bin/atpootb-autostart'",
              "test -f '${aeroPackage}/share/wayland-sessions/aerothemeplasma.desktop'",
              "test -f '${aeroPackage}/lib/qt-6/qml/aeroshell/utils/qmldir'",
              "grep -qxF 'Exec=${aeroPackage}/bin/atpootb-autostart' '${aeroPackage}/etc/xdg/autostart/x-atpootb.desktop'",
              "grep -qxF 'Theme=Windows 7 Aero' '${aeroPackage}/etc/xdg/aerothemeplasma/kdeglobals'",
              "grep -qxF 'Theme=Windows 7' '${aeroPackage}/etc/xdg/aerothemeplasma/kdeglobals'",
              "grep -qxF 'cursorTheme=aero-drop' '${aeroPackage}/etc/xdg/aerothemeplasma/kcminputrc'",
              "test -f '/run/current-system/sw/share/icons/Windows 7 Aero/index.theme'",
              "test -f /run/current-system/sw/share/icons/aero-drop/index.theme",
              "test -f '/run/current-system/sw/share/sounds/Windows 7/index.theme'",
              "test -f '${uacAgent}/share/systemd/user/plasma-polkit-agent.service.d/uac-polkit-agent.conf'",
          )

      with subtest("Check KWin components are installed"):
          machine.succeed(
              "test -f /run/current-system/sw/lib/qt-6/plugins/org.kde.kdecoration3/org.smod.smod.so",
              "test -f /run/current-system/sw/lib/qt-6/plugins/kwin/effects/plugins/aeroglassblur.so",
              "test -f /run/current-system/sw/lib/plugins/kwin-x11/effects/plugins/aeroglassblur.so",
          )

      with subtest("Check the start menu and taskbar plasmoids loaded"):
          machine.fail(
              "journalctl -b | grep -E 'error loading (SevenStart|SevenTasks)|MenuRepresentation unavailable|Cannot assign to non-existent property'"
          )

      with subtest("Check the UAC agent registered as the session's polkit agent"):
          machine.wait_until_succeeds("pgrep -f uac-polkit-agent")
          machine.wait_until_succeeds(
              "journalctl -b | grep -F 'uac-polkit-agent' | grep -q 'Listener online'"
          )

      with subtest("Check the AeroThemePlasma lock screen loads"):
          machine.succeed(
              "sudo -u alice env XDG_RUNTIME_DIR=/run/user/1000 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus busctl --user call org.freedesktop.ScreenSaver /ScreenSaver org.freedesktop.ScreenSaver Lock"
          )
          machine.wait_until_succeeds("pgrep -f kscreenlocker_greet")
          machine.fail(
              "journalctl -b | grep -F 'module \"aeroshell.utils\" is not installed'"
          )

      with subtest("Check the configured SDDM greeter renders"):
          greeter.wait_until_succeeds("pgrep -f sddm-greeter")
          greeter.succeed(
              "grep -qxF 'Current=${aeroTheme}' /etc/sddm.conf.d/00-nixos.conf"
          )
          greeter.wait_for_text(r"(Password|alice|Alice)")
          greeter.fail(
              "journalctl -b | grep -iE 'could not load theme|module \"QtMultimedia\" is not installed'"
          )

      with subtest("Check the disabled options and stock session fallback"):
          wait_for_shell(stock)
          stock.fail(
              "grep -qF '${forkLibplasma}' /proc/$(pgrep -o plasmashell)/maps"
          )
          stock.fail(
              "grep -qxF 'Current=${aeroTheme}' /etc/sddm.conf.d/00-nixos.conf"
          )
          stock.fail(
              "test -e /run/current-system/sw/lib/qt-6/plugins/org.kde.kdecoration3/org.smod.smod.so"
          )
          stock.fail(
              "test -e /run/current-system/sw/lib/qt-6/plugins/kwin/effects/plugins/aeroglassblur.so"
          )
          stock.fail(
              "test -e '/run/current-system/sw/share/icons/Windows 7 Aero/index.theme'"
          )
          stock.fail(
              "test -e '/run/current-system/sw/share/sounds/Windows 7/index.theme'"
          )
          stock.wait_until_succeeds("pgrep -f polkit-kde-authentication-agent-1")
          stock.fail("pgrep -f uac-polkit-agent")
    '';
}
