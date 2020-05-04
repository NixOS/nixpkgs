/* List of maintainer teams.
    name = {
      # Required
      members = [ maintainer1 maintainer2 ];
      scope = "Maintain foo packages.";
    };

  where

  - `members` is the list of maintainers belonging to the group,
  - `scope` describes the scope of the group.

  More fields may be added in the future.

  Please keep the list alphabetically sorted.
  */

{ lib }:
with lib.maintainers; {
  acme = {
    members = [
      aanderse
      andrew-d
      arianvp
      emily
      flokli
      m1cr0man
    ];
    scope = "Maintain ACME-related packages and modules.";
  };

  freedesktop = {
    members = [ jtojnar worldofpeace ];
    scope = "Maintain Freedesktop.org packages for graphical desktop.";
  };

  gnome = {
    members = [
      hedning
      jtojnar
      worldofpeace
    ];
    scope = "Maintain GNOME desktop environment and platform.";
  };

  php = {
    members = [
      aanderse
      etu
      globin
      ma27
      talyz
    ];
    scope = "Maintain PHP related packages and extensions.";
  };

  podman = {
    members = [
      adisbladis
      saschagrunert
      vdemeester
      zowoq
    ];
    scope = "Maintain Podman and CRI-O related packages and modules.";
  };
}
