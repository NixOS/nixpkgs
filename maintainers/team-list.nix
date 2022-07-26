/* List of maintainer teams.
    name = {
      # Required
      members = [ maintainer1 maintainer2 ];
      scope = "Maintain foo packages.";
      shortName = "foo";
      # Optional
      enableFeatureFreezePing = true;
      githubTeams = [ "my-subsystem" ];
    };

  where

  - `members` is the list of maintainers belonging to the group,
  - `scope` describes the scope of the group.
  - `shortName` short human-readable name
  - `enableFeatureFreezePing` will ping this team during the Feature Freeze announcements on releases
  - `githubTeams` will ping specified GitHub teams as well

  More fields may be added in the future.

  When editing this file:
   * keep the list alphabetically sorted
   * test the validity of the format with:
       nix-build lib/tests/teams.nix
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
    shortName = "ACME";
  };

  bazel = {
    members = [
      mboes
      marsam
      uri-canva
      cbley
      olebedev
      groodt
      aherrmann
      ylecornec
    ];
    scope = "Bazel build tool & related tools https://bazel.build/";
    shortName = "Bazel";
    enableFeatureFreezePing = true;
  };

  beam = {
    members = [
      ankhers
      Br1ght0ne
      DianaOlympos
      gleber
      happysalada
      minijackson
      yurrriq
    ];
    githubTeams = [
      "beam"
    ];
    scope = "Maintain BEAM-related packages and modules.";
    shortName = "BEAM";
    enableFeatureFreezePing = true;
  };

  blockchains = {
    members = [
      mmahut
      RaghavSood
    ];
    scope = "Maintain Blockchain packages and modules.";
    shortName = "Blockchains";
    enableFeatureFreezePing = true;
  };

  c = {
    members = [
      matthewbauer
      mic92
    ];
    scope = "Maintain C libraries and tooling.";
    shortName = "C";
    enableFeatureFreezePing = true;
  };

  c3d2 = {
    members = [
      astro
      SuperSandro2000
      revol-xut
    ];
    scope = "Maintain packages used in the C3D2 hackspace";
    shortName = "c3d2";
    enableFeatureFreezePing = true;
  };

  cinnamon = {
    members = [
      mkg20001
    ];
    scope = "Maintain Cinnamon desktop environment and applications made by the LinuxMint team.";
    shortName = "Cinnamon";
    enableFeatureFreezePing = true;
  };

  chia = {
    members = [
      lourkeur
    ];
    scope = "Maintain the Chia blockchain and its dependencies";
    shortName = "Chia Blockchain";
  };

  coq = {
    members = [
      cohencyril
      Zimmi48
      # gares has no entry in the maintainers list
      siraben
      vbgl
    ];
    scope = "Maintain the Coq theorem prover and related packages.";
    shortName = "Coq";
    enableFeatureFreezePing = true;
  };

  darwin = {
    members = [
      toonn
    ];
    githubTeams = [
      "darwin-maintainers"
    ];
    scope = "Maintain Darwin compatibility of packages and Darwin-only packages.";
    shortName = "Darwin";
    enableFeatureFreezePing = true;
  };

  cosmopolitan = {
    members = [
      lourkeur
      tomberek
    ];
    scope = "Maintain the Cosmopolitan LibC and related programs.";
    shortName = "Cosmopolitan";
  };

  deshaw = {
    # Verify additions to this team with at least one already existing member of the team.
    members = [
      limeytexan
    ];
    scope = "Group registration for D. E. Shaw employees who collectively maintain packages.";
    shortName = "Shaw employees";
  };

  determinatesystems = {
    # Verify additions to this team with at least one already existing member of the team.
    members = [
      cole-h
      grahamc
    ];
    scope = "Group registration for packages maintained by Determinate Systems.";
    shortName = "Determinate Systems employees";
  };

  dhall = {
    members = [
      Gabriel439
      ehmry
    ];
    scope = "Maintain Dhall and related packages.";
    shortName = "Dhall";
    enableFeatureFreezePing = true;
  };

  docker = {
    members = [
      roberth
      utdemir
    ];
    scope = "Maintain Docker and related tools.";
    shortName = "DockerTools";
    enableFeatureFreezePing = true;
  };

  docs = {
    members = [
      ryantm
    ];
    scope = "Maintain nixpkgs/NixOS documentation and tools for building it.";
    shortName = "Docs";
    enableFeatureFreezePing = true;
  };

  emacs = {
    members = [
      adisbladis
    ];
    scope = "Maintain the Emacs editor and packages.";
    shortName = "Emacs";
    enableFeatureFreezePing = true;
  };

  enlightenment = {
    members = [
      romildo
    ];
    githubTeams = [
      "enlightenment"
    ];
    scope = "Maintain Enlightenment desktop environment and related packages.";
    shortName = "Enlightenment";
    enableFeatureFreezePing = true;
  };

  # Dummy group for the "everyone else" section
  feature-freeze-everyone-else = {
    members = [ ];
    githubTeams = [
      "nixpkgs-committers"
      "release-engineers"
    ];
    scope = "Dummy team for the #everyone else' section during feture freezes, not to be used as package maintainers!";
    shortName = "Everyone else";
    enableFeatureFreezePing = true;
  };

  freedesktop = {
    members = [ jtojnar ];
    scope = "Maintain Freedesktop.org packages for graphical desktop.";
    shortName = "freedesktop.org packaging";
  };

  gcc = {
    members = [
      synthetica
      vcunat
      ericson2314
    ];
    scope = "Maintain GCC (GNU Compiler Collection) compilers";
    shortName = "GCC";
  };

  golang = {
    members = [
      c00w
      cstrahan
      Frostman
      kalbasit
      mic92
      orivej
      rvolosatovs
      zowoq
    ];
    scope = "Maintain Golang compilers.";
    shortName = "Go";
    enableFeatureFreezePing = true;
  };

  gnome = {
    members = [
      bobby285271
      hedning
      jtojnar
      dasj19
      maxeaubrey
    ];
    githubTeams = [
      "gnome"
    ];
    scope = "Maintain GNOME desktop environment and platform.";
    shortName = "GNOME";
    enableFeatureFreezePing = true;
  };

  haskell = {
    members = [
      cdepillabout
      expipiplus1
      maralorn
      sternenseemann
    ];
    githubTeams = [
      "haskell"
    ];
    scope = "Maintain Haskell packages and infrastructure.";
    shortName = "Haskell";
    enableFeatureFreezePing = true;
  };

  home-assistant = {
    members = [
      fab
      globin
      hexa
      mic92
    ];
    scope = "Maintain the Home Assistant ecosystem";
    shortName = "Home Assistant";
  };

  iog = {
    members = [
      cleverca22
      disassembler
      jonringer
      manveru
      nrdxp
    ];
    scope = "Input-Output Global employees, which maintain critical software";
    shortName = "Input-Output Global employees";
  };

  jitsi = {
    members = [
      cleeyv
      ryantm
      yuka
    ];
    scope = "Maintain Jitsi.";
    shortName = "Jitsi";
  };

  kubernetes = {
    members = [
      johanot
      offline
      saschagrunert
      srhb
      zowoq
    ];
    scope = "Maintain the Kubernetes package and module";
    shortName = "Kubernetes";
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
    shortName = "Kodi";
  };

  linux-kernel = {
    members = [
      TredwellGit
      ma27
      nequissimus
      qyliss
    ];
    scope = "Maintain the Linux kernel.";
    shortName = "Linux Kernel";
  };

  lumiguide = {
    # Verify additions by approval of an already existing member of the team.
    members = [
      roelvandijk
      lucus16
    ];
    scope = "Group registration for LumiGuide employees who collectively maintain packages.";
    shortName = "Lumiguide employees";
  };

  lumina = {
    members = [
      romildo
    ];
    githubTeams = [
      "lumina"
    ];
    scope = "Maintain lumina desktop environment and related packages.";
    shortName = "Lumina";
    enableFeatureFreezePing = true;
  };

  lxqt = {
    members = [
      romildo
    ];
    githubTeams = [
      "lxqt"
    ];
    scope = "Maintain LXQt desktop environment and related packages.";
    shortName = "LXQt";
    enableFeatureFreezePing = true;
  };

  marketing = {
    members = [
      garbas
      tomberek
    ];
    scope = "Marketing of Nix/NixOS/nixpkgs.";
    shortName = "Marketing";
    enableFeatureFreezePing = true;
  };

  mate = {
    members = [
      j03
      romildo
    ];
    scope = "Maintain Mate desktop environment and related packages.";
    shortName = "MATE";
  };

  matrix = {
    members = [
      ma27
      fadenb
      mguentner
      ekleog
      ralith
      dandellion
      sumnerevans
    ];
    scope = "Maintain the ecosystem around Matrix, a decentralized messenger.";
    shortName = "Matrix";
  };

  mobile = {
    members = [
      samueldr
    ];
    scope = "Maintain Mobile NixOS.";
    shortName = "Mobile";
    enableFeatureFreezePing = true;
  };

  nix = {
    members = [
      Profpatsch
      eelco
      grahamc
      pierron
    ];
    scope = "Maintain the Nix package manager.";
    shortName = "Nix/nix-cli ecosystem";
    enableFeatureFreezePing = true;
  };

  nixos-modules = {
    members = [
      ericson2314
      infinisil
      qyliss
      roberth
    ];
    scope = "Maintain nixpkgs module system internals.";
    shortName = "NixOS Modules / internals";
    enableFeatureFreezePing = true;
  };

  numtide = {
    members = [
      mic92
      flokli
      jfroche
      tazjin
      zimbatm
    ];
    enableFeatureFreezePing = true;
    scope = "Group registration for Numtide team members who collectively maintain packages.";
    shortName = "Numtide team";
  };

  openstack = {
    members = [
      emilytrau
      SuperSandro2000
    ];
    scope = "Maintain the ecosystem around OpenStack";
    shortName = "OpenStack";
  };

  pantheon = {
    members = [
      davidak
      bobby285271
    ];
    githubTeams = [
      "pantheon"
    ];
    scope = "Maintain Pantheon desktop environment and platform.";
    shortName = "Pantheon";
    enableFeatureFreezePing = true;
  };

  perl = {
    members = [
      sgo
    ];
    scope = "Maintain the Perl interpreter and Perl packages.";
    shortName = "Perl";
    enableFeatureFreezePing = true;
  };

  php = {
    members = [
      aanderse
      drupol
      etu
      globin
      ma27
      talyz
    ];
    githubTeams = [
      "php"
    ];
    scope = "Maintain PHP related packages and extensions.";
    shortName = "PHP";
    enableFeatureFreezePing = true;
  };

  podman = {
    members = [
      adisbladis
      saschagrunert
      vdemeester
      zowoq
    ];
    githubTeams = [
      "podman"
    ];
    scope = "Maintain Podman and CRI-O related packages and modules.";
    shortName = "Podman";
    enableFeatureFreezePing = true;
  };

  postgres = {
    members = [
      thoughtpolice
    ];
    scope = "Maintain the PostgreSQL package and plugins along with the NixOS module.";
    shortName = "PostgreSQL";
    enableFeatureFreezePing = true;
  };

  python = {
    members = [
      fridh
      hexa
      jonringer
    ];
    scope = "Maintain the Python interpreter and related packages.";
    shortName = "Python";
    enableFeatureFreezePing = true;
  };

  qt-kde = {
    members = [
      ttuegel
    ];
    githubTeams = [
      "qt-kde"
    ];
    scope = "Maintain the KDE desktop environment and Qt.";
    shortName = "Qt / KDE";
    enableFeatureFreezePing = true;
  };

  r = {
    members = [
      bcdarwin
      jbedo
    ];
    scope = "Maintain the R programming language and related packages.";
    shortName = "R";
    enableFeatureFreezePing = true;
  };

  redcodelabs = {
    members = [
      unrooted
      wr0belj
      wintrmvte
    ];
    scope = "Maintain Red Code Labs related packages and modules.";
    shortName = "Red Code Labs";
  };

  release = {
    members = [ ];
    githubTeams = [
      "nixos-release-managers"
    ];
    scope = "Manage the current nixpkgs/NixOS release.";
    shortName = "Release";
    enableFeatureFreezePing = true;
  };

  ruby = {
    members = [
      marsam
    ];
    scope = "Maintain the Ruby interpreter and related packages.";
    shortName = "Ruby";
    enableFeatureFreezePing = true;
  };

  rust = {
    members = [
      andir
      lnl7
      mic92
      zowoq
    ];
    scope = "Maintain the Rust compiler toolchain and nixpkgs integration.";
    shortName = "Rust";
    enableFeatureFreezePing = true;
  };

  sage = {
    members = [
      timokau
      omasanori
      raskin
      collares
    ];
    scope = "Maintain SageMath and the dependencies that are likely to break it.";
    shortName = "SageMath";
  };

  sphinx = {
    members = [
      SuperSandro2000
    ];
    scope = "Maintain Sphinx related packages.";
    shortName = "Sphinx";
  };

  serokell = {
    # Verify additions by approval of an already existing member of the team.
    members = [
      balsoft
      mkaito
    ];
    scope = "Group registration for Serokell employees who collectively maintain packages.";
    shortName = "Serokell employees";
  };

  systemd = {
    members = [ ];
    githubTeams = [
      "systemd"
    ];
    scope = "Maintain systemd for NixOS.";
    shortName = "systemd";
    enableFeatureFreezePing = true;
  };

  tests = {
    members = [
      tfc
    ];
    scope = "Maintain the NixOS VM test runner.";
    shortName = "NixOS tests";
    enableFeatureFreezePing = true;
  };

  tts = {
    members = [
      hexa
      mic92
    ];
    scope = "coqui-ai TTS (formerly Mozilla TTS) and leaf packages";
    shortName = "coqui-ai TTS";
  };

  vim = {
    members = [
      jonringer
      softinio
      teto
    ];
    scope = "Maintain the vim and neovim text editors and related packages.";
    shortName = "Vim/Neovim";
    enableFeatureFreezePing = true;
  };

  xfce = {
    members = [
      romildo
    ];
    scope = "Maintain Xfce desktop environment and related packages.";
    shortName = "Xfce";
  };
}
