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

  cinnamon = {
    members = [
      mkg20001
    ];
    scope = "Maintain Cinnamon desktop environment and applications made by the LinuxMint team.";
  };

  deshaw = {
    # Verify additions to this team with at least one already existing member of the team.
    members = [
      limeytexan
    ];
    scope = "Group registration for D. E. Shaw employees who collectively maintain packages.";
  };

  freedesktop = {
    members = [ jtojnar worldofpeace ];
    scope = "Maintain Freedesktop.org packages for graphical desktop.";
  };

  golang = {
    members = [
      c00w
      cstrahan
      Frostman
      kalbasit
      mdlayher
      mic92
      orivej
      rvolosatovs
      zowoq
    ];
    scope = "Maintain Golang compilers.";
  };

  gnome = {
    members = [
      hedning
      jtojnar
      worldofpeace
      dasj19
    ];
    scope = "Maintain GNOME desktop environment and platform.";
  };

  jitsi = {
    members = [
      mmilata
      petabyteboy
      prusnak
      ryantm
    ];
    scope = "Maintain Jitsi.";
  };

  matrix = {
    members = [
      ma27
      pacien
      fadenb
      mguentner
      ekleog
      ralith
    ];
    scope = "Maintain the ecosystem around Matrix, a decentralized messenger.";
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

  sage = {
    members = [
      timokau
      omasanori
      raskin
    ];
    scope = "Maintain SageMath and the dependencies that are likely to break it.";
  };
}
