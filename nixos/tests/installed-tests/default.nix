# NixOS tests for gnome-desktop-testing-runner using software
# See https://wiki.gnome.org/Initiatives/GnomeGoals/InstalledTests

{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../../.. { inherit system config; }
}:

with import ../../lib/testing-python.nix { inherit system pkgs; };
with pkgs.lib;

let

  callInstalledTest = pkgs.newScope { inherit makeInstalledTest; };

  makeInstalledTest =
    { # Package to test. Needs to have an installedTests output
      tested

      # Config to inject into machine
    , testConfig ? {}

      # Test script snippet to inject before gnome-desktop-testing-runner begins.
      # This is useful for extra setup the environment may need before the runner begins.
    , preTestScript ? ""

      # Does test need X11?
    , withX11 ? false

      # Extra flags to pass to gnome-desktop-testing-runner.
    , testRunnerFlags ? ""

      # Extra attributes to pass to makeTest.
      # They will be recursively merged into the attrset created by this function.
    , ...
    }@args:
    makeTest
      (recursiveUpdate
        rec {
          name = tested.name;

          meta = {
            maintainers = tested.meta.maintainers or [];
          };

          nodes.machine = { ... }: {
            imports = [
              testConfig
            ] ++ optional withX11 ../common/x11.nix;

            environment.systemPackages = with pkgs; [ gnome-desktop-testing ];

            # The installed tests need to be added to the test VM’s closure.
            # Otherwise, their dependencies might not actually be registered
            # as valid paths in the VM’s Nix store database,
            # and `nix-store --query` commands run as part of the tests
            # (for example when building Flatpak runtimes) will fail.
            environment.variables.TESTED_PACKAGE_INSTALLED_TESTS = "${tested.installedTests}/share";
          };

          testScript =
            optionalString withX11 ''
              machine.wait_for_x()
            '' +
            optionalString (preTestScript != "") ''
              ${preTestScript}
            '' +
            ''
              machine.succeed(
                  "gnome-desktop-testing-runner ${testRunnerFlags} -d '${tested.installedTests}/share'"
              )
            '';
        }

        (removeAttrs args [
          "tested"
          "testConfig"
          "preTestScript"
          "withX11"
          "testRunnerFlags"
        ])
      );

in

{
  appstream = callInstalledTest ./appstream.nix {};
  appstream-qt = callInstalledTest ./appstream-qt.nix {};
  colord = callInstalledTest ./colord.nix {};
  flatpak = callInstalledTest ./flatpak.nix {};
  flatpak-builder = callInstalledTest ./flatpak-builder.nix {};
  fwupd = callInstalledTest ./fwupd.nix {};
  gcab = callInstalledTest ./gcab.nix {};
  gdk-pixbuf = callInstalledTest ./gdk-pixbuf.nix {};
  geocode-glib = callInstalledTest ./geocode-glib.nix {};
  gjs = callInstalledTest ./gjs.nix {};
  glib-networking = callInstalledTest ./glib-networking.nix {};
  gnome-photos = callInstalledTest ./gnome-photos.nix {};
  graphene = callInstalledTest ./graphene.nix {};
  gsconnect = callInstalledTest ./gsconnect.nix {};
  json-glib = callInstalledTest ./json-glib.nix {};
  ibus = callInstalledTest ./ibus.nix {};
  libgdata = callInstalledTest ./libgdata.nix {};
  librsvg = callInstalledTest ./librsvg.nix {};
  glib-testing = callInstalledTest ./glib-testing.nix {};
  libjcat = callInstalledTest ./libjcat.nix {};
  libxmlb = callInstalledTest ./libxmlb.nix {};
  malcontent = callInstalledTest ./malcontent.nix {};
  ostree = callInstalledTest ./ostree.nix {};
  pipewire = callInstalledTest ./pipewire.nix {};
  xdg-desktop-portal = callInstalledTest ./xdg-desktop-portal.nix {};
}
