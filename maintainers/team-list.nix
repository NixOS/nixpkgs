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

  beam = {
    members = [
      ankhers
      Br1ght0ne
      DianaOlympos
      gleber
      happysalada
      yurrriq
    ];
    scope = "Maintain BEAM-related packages and modules.";
  };

  cinnamon = {
    members = [
      mkg20001
    ];
    scope = "Maintain Cinnamon desktop environment and applications made by the LinuxMint team.";
  };

  chia = {
    members = [
      atemu
      lourkeur
    ];
    scope = "Maintain the Chia blockchain and its dependencies";
  };

  deshaw = {
    # Verify additions to this team with at least one already existing member of the team.
    members = [
      limeytexan
    ];
    scope = "Group registration for D. E. Shaw employees who collectively maintain packages.";
  };

  determinatesystems = {
    # Verify additions to this team with at least one already existing member of the team.
    members = [
      cole-h
      grahamc
    ];
    scope = "Group registration for packages maintained by Determinate Systems.";
  };

  freedesktop = {
    members = [ jtojnar ];
    scope = "Maintain Freedesktop.org packages for graphical desktop.";
  };

  gcc = {
    members = [
      synthetica
      vcunat
      ericson2314
    ];
    scope = "Maintain GCC (GNU Compiler Collection) compilers";
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
      dasj19
      maxeaubrey
    ];
    scope = "Maintain GNOME desktop environment and platform.";
  };

  haskell = {
    members = [
      maralorn
      cdepillabout
      sternenseemann
    ];
    scope = "Maintain Haskell packages and infrastructure.";
  };

  home-assistant = {
    members = [
      fab
      globin
      hexa
      mic92
    ];
    scope = "Maintain the Home Assistant ecosystem";
  };

  jitsi = {
    members = [
      petabyteboy
      ryantm
      yuka
    ];
    scope = "Maintain Jitsi.";
  };

  kodi = {
    members = [
      aanderse
      cpages
      edwtjo
      minijackson
      peterhoeg
      sephalon
    ];
    scope = "Maintain Kodi and related packages.";
  };

  matrix = {
    members = [
      ma27
      fadenb
      mguentner
      ekleog
      ralith
      mjlbach
      dandellion
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
      collares
    ];
    scope = "Maintain SageMath and the dependencies that are likely to break it.";
  };

  serokell = {
    # Verify additions by approval of an already existing member of the team.
    members = [
      balsoft
      mkaito
    ];
    scope = "Group registration for Serokell employees who collectively maintain packages.";
  };

  tts = {
    members = [
      hexa
      mic92
    ];
    scope = "coqui-ai TTS (formerly Mozilla TTS) and leaf packages";
  };
}
