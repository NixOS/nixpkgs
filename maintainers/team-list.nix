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
    - There is limited mention capacity in a single post, so this should be reserved for critical components
      or larger ecosystems within nixpkgs.
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
      arianvp
      emily
      flokli
      m1cr0man
    ];
    scope = "Maintain ACME-related packages and modules.";
    shortName = "ACME";
    enableFeatureFreezePing = true;
  };

  bazel = {
    members = [
      mboes
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

  bitnomial = {
    # Verify additions to this team with at least one already existing member of the team.
    members = [
      cdepillabout
      wraithm
    ];
    scope = "Group registration for packages maintained by Bitnomial.";
    shortName = "Bitnomial employees";
  };

  blockchains = {
    members = [
      mmahut
      RaghavSood
    ];
    scope = "Maintain Blockchain packages and modules.";
    shortName = "Blockchains";
  };

  budgie = {
    members = [
      bobby285271
    ];
    scope = "Maintain Budgie desktop environment";
    shortName = "Budgie";
  };

  buildbot = {
    members = [
      lopsided98
      mic92
      zowoq
    ];
    scope = "Maintain Buildbot CI framework";
    shortName = "Buildbot";
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
      oxapentane
    ];
    scope = "Maintain packages used in the C3D2 hackspace";
    shortName = "c3d2";
  };

  cinnamon = {
    members = [
      bobby285271
      mkg20001
    ];
    scope = "Maintain Cinnamon desktop environment and applications made by the Linux Mint team.";
    shortName = "Cinnamon";
    enableFeatureFreezePing = true;
  };

  cloudposse = {
    members = [
      dudymas
    ];
    scope = "Maintain atmos and applications made by the Cloud Posse team.";
    shortName = "CloudPosse";
    enableFeatureFreezePing = true;
  };

  coq = {
    members = [
      cohencyril
      Zimmi48
      # gares has no entry in the maintainers list
      siraben
      vbgl
      alizter
    ];
    scope = "Maintain the Coq theorem prover and related packages.";
    shortName = "Coq";
    enableFeatureFreezePing = true;
  };

  cuda = {
    members = [
      connorbaker
      samuela
      SomeoneSerge
    ];
    scope = "Maintain CUDA-enabled packages";
    shortName = "Cuda";
    githubTeams = [ "cuda-maintainers" ];
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
      bbjubjub
      tomberek
    ];
    scope = "Maintain the Cosmopolitan LibC and related programs.";
    shortName = "Cosmopolitan";
  };

  dotnet = {
    members = [
      ivar
      mdarocha
      corngood
      ggg
      raphaelr
      jamiemagee
      anpin
    ];
    scope = "Maintainers of the .NET build tools and packages";
    shortName = "dotnet";
  };

  deepin = {
    members = [
      rewine
    ];
    scope = "Maintain deepin desktop environment and related packages.";
    shortName = "DDE";
    enableFeatureFreezePing = true;
  };

  deshaw = {
    # Verify additions to this team with at least one already existing member of the team.
    members = [
      de11n
      invokes-su
    ];
    scope = "Group registration for D. E. Shaw employees who collectively maintain packages.";
    shortName = "D. E. Shaw employees";
  };

  determinatesystems = {
    # Verify additions to this team with at least one already existing member of the team.
    members = [
      cole-h
      grahamc
      hoverbear
    ];
    scope = "Group registration for packages maintained by Determinate Systems.";
    shortName = "Determinate Systems employees";
  };

  dhall = {
    members = [
      Gabriella439
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
  };

  docs = {
    members = [ ];
    githubTeams = [
      "documentation-team"
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

  flutter = {
    members = [ mkg20001 RossComputerGuy FlafyDev hacker1024 ];
    scope = "Maintain Flutter and Dart-related packages and build tools";
    shortName = "flutter";
    enableFeatureFreezePing = false;
    githubTeams = [ "flutter" ];
  };

  flyingcircus = {
    # Verify additions by approval of an already existing member of the team.
    members = [
      theuni
      dpausp
      frlan
      leona
      osnyx
      ma27
    ];
    scope = "Team for Flying Circus employees who collectively maintain packages.";
    shortName = "Flying Circus employees";
  };

  formatter = {
    members = [
      piegames
      infinisil
      das_j
      tomberek
      _0x4A6F
      # Not in the maintainer list
      # Sereja313
    ];
    scope = "Tentative Nix formatter team to be established in https://github.com/NixOS/rfcs/pull/166";
    shortName = "Nix formatter team";
  };

  freedesktop = {
    members = [ jtojnar ];
    scope = "Maintain Freedesktop.org packages for graphical desktop.";
    shortName = "freedesktop.org packaging";
  };

  fslabs = {
    # Verify additions to this team with at least one already existing member of the team.
    members = [
      greaka
      lpostula
    ];
    scope = "Group registration for packages maintained by Foresight Spatial Labs.";
    shortName = "Foresight Spatial Labs employees";
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

  geospatial = {
    members = [
      imincik
      l0b0
      nh2
      nialov
      sikmir
      willcohen
    ];
    githubTeams = [
      "geospatial"
    ];
    scope = "Maintain geospatial packages.";
    shortName = "Geospatial";
    enableFeatureFreezePing = true;
  };

  gitlab = {
    members = [
      globin
      krav
      talyz
      yayayayaka
    ];
    scope = "Maintain gitlab packages.";
    shortName = "gitlab";
  };

  golang = {
    members = [
      kalbasit
      mic92
      zowoq
      qbit
      mfrw
    ];
    githubTeams = [
      "golang"
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
    ];
    githubTeams = [
      "gnome"
    ];
    scope = "Maintain GNOME desktop environment and platform.";
    shortName = "GNOME";
    enableFeatureFreezePing = true;
  };

  graalvm-ce = {
    members = [
      bandresen
      hlolli
      glittershark
      babariviere
      ericdallo
      thiagokokada
    ];
    scope = "Maintain GraalVM Community Edition packages.";
    shortName = "GraalVM-CE";
  };

  haskell = {
    members = [
      cdepillabout
      expipiplus1
      maralorn
      ncfavier
      sternenseemann
    ];
    githubTeams = [
      "haskell"
    ];
    scope = "Maintain Haskell packages and infrastructure.";
    shortName = "Haskell";
    enableFeatureFreezePing = true;
  };

  helsinki-systems = {
    # Verify additions to this team with at least one already existing member of the team.
    members = [
      das_j
      conni2461
    ];
    scope = "Group registration for packages maintained by Helsinki Systems";
    shortName = "Helsinki Systems employees";
  };

  home-assistant = {
    members = [
      fab
      hexa
      mic92
    ];
    scope = "Maintain the Home Assistant ecosystem";
    shortName = "Home Assistant";
  };

  infisical = {
    members = [
      akhilmhdh
    ];
    scope = "Maintain Infisical";
    shortName = "Infisical";
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
      lassulus
      yayayayaka
      asymmetric
    ];
    scope = "Maintain Jitsi.";
    shortName = "Jitsi";
  };

  jupyter = {
    members = [
      GaetanLepage
      natsukium
      thomasjm
    ];
    scope = "Maintain Jupyter and related packages.";
    shortName = "Jupyter";
  };

  kubernetes = {
    members = [
      johanot
      offline
      saschagrunert
      srhb
    ];
    scope = "Maintain the Kubernetes package and module";
    shortName = "Kubernetes";
  };

  kodi = {
    members = [
      aanderse
      cpages
      dschrempf
      edwtjo
      kazenyuk
      minijackson
      peterhoeg
      sephalon
    ];
    scope = "Maintain Kodi and related packages.";
    shortName = "Kodi";
  };

  libretro = {
    members = [
      aanderse
      edwtjo
      thiagokokada
    ];
    scope = "Maintain Libretro, RetroArch and related packages.";
    shortName = "Libretro";
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

  lisp = {
    members = [
      raskin
      lukego
      nagy
      uthar
      hraban
    ];
    githubTeams = [
      "lisp"
    ];
    scope = "Maintain the Lisp ecosystem.";
    shortName = "lisp";
    enableFeatureFreezePing = true;
  };

  llvm = {
    members = [
      dtzWill
      ericson2314
      lovek323
      qyliss
      RossComputerGuy
      rrbutani
      sternenseemann
    ];
    githubTeams = [
      "llvm"
    ];
    scope = "Maintain LLVM package sets and related packages";
    shortName = "LLVM";
    enableFeatureFreezePing = true;
  };

  lomiri = {
    members = [
      OPNA2608
    ];
    scope = "Maintain Lomiri desktop environment and related packages.";
    shortName = "Lomiri";
    enableFeatureFreezePing = true;
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

  lua = {
    githubTeams = [
      "lua"
    ];
    scope = "Maintain the lua ecosystem.";
    shortName = "lua";
    enableFeatureFreezePing = true;
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

  lxc = {
    members = [
      aanderse
      adamcstephens
      jnsgruk
      megheaiulian
      mkg20001
    ];
    scope = "All things linuxcontainers. LXC, Incus, LXD and related packages.";
    shortName = "lxc";
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
      bobby285271
      j03
      romildo
    ];
    scope = "Maintain Mate desktop environment and related packages.";
    shortName = "MATE";
    enableFeatureFreezePing = true;
  };

  matrix = {
    members = [
      ma27
      fadenb
      mguentner
      ralith
      dandellion
      sumnerevans
      nickcao
    ];
    scope = "Maintain the ecosystem around Matrix, a decentralized messenger.";
    shortName = "Matrix";
  };

  minimal-bootstrap = {
    members = [
      alejandrosame
      artturin
      emilytrau
      ericson2314
      jk
      siraben
    ];
    scope = "Maintain the minimal-bootstrap toolchain and related packages.";
    shortName = "Minimal Bootstrap";
  };

  mercury = {
    members = [
      _9999years
      Gabriella439
    ];
    scope = "Group registry for packages maintained by Mercury";
    shortName = "Mercury Employees";
  };

  mobile = {
    members = [
      samueldr
    ];
    scope = "Maintain Mobile NixOS.";
    shortName = "Mobile";
  };

  nix = {
    members = [
      eelco
      grahamc
      pierron
    ];
    scope = "Maintain the Nix package manager.";
    shortName = "Nix/nix-cli ecosystem";
    enableFeatureFreezePing = true;
  };

  lix = {
    members = [
      raitobezarius
      qyriad
    ];
    scope = "Maintain the Lix package manager inside of Nixpkgs.";
    shortName = "Lix ecosystem";
    enableFeatureFreezePing = true;
  };

  module-system = {
    members = [
      infinisil
      roberth
    ];
    scope = "Maintain the Nixpkgs module system.";
    shortName = "Module system";
    enableFeatureFreezePing = true;
  };

  node = {
    members = [
      lilyinstarlight
      winter
    ];
    scope = "Maintain Node.js runtimes and build tooling.";
    shortName = "Node.js";
    enableFeatureFreezePing = true;
  };

  ocaml = {
    members = [
      alizter
    ];
    githubTeams = [
      "ocaml"
    ];
    scope = "Maintain the OCaml compiler and package set.";
    shortName = "OCaml";
    enableFeatureFreezePing = true;
  };

  openstack = {
    members = [
      SuperSandro2000
    ];
    scope = "Maintain the ecosystem around OpenStack";
    shortName = "OpenStack";
  };

  ororatech = {
    # email: nixdevs@ororatech.com
    shortName = "OroraTech GmbH. employees";
    scope = "Team for packages maintained by employees of OroraTech GmbH.";
    # Edits to this list should only be done by an already existing member.
    members = [
      kip93
      victormeriqui
    ];
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
      ma27
      patka
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
      saschagrunert
      vdemeester
    ];
    githubTeams = [
      "podman"
    ];
    scope = "Maintain Podman and CRI-O related packages and modules.";
    shortName = "Podman";
  };

  postgres = {
    members = [
      thoughtpolice
    ];
    scope = "Maintain the PostgreSQL package and plugins along with the NixOS module.";
    shortName = "PostgreSQL";
  };

  python = {
    members = [
      hexa
      jonringer
      tjni
    ];
    scope = "Maintain the Python interpreter and related packages.";
    shortName = "Python";
    enableFeatureFreezePing = true;
  };

  qt-kde = {
    members = [
      ilya-fedin
      k900
      LunNova
      mjm
      nickcao
      SuperSandro2000
      ttuegel
    ];
    githubTeams = [
      "qt-kde"
    ];
    scope = "Maintain the Qt framework, KDE application suite, Plasma desktop environment and related projects.";
    shortName = "Qt / KDE";
    enableFeatureFreezePing = true;
  };

  r = {
    members = [
      b-rodrigues
      bcdarwin
      jbedo
      kupac
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
  };

  rocm = {
    members = [
      Madouura
      Flakebi
      mschwaig
    ];
    githubTeams = [
      "rocm-maintainers"
    ];
    scope = "Maintain ROCm and related packages.";
    shortName = "ROCm";
  };

  ruby = {
    members = [
    ];
    scope = "Maintain the Ruby interpreter and related packages.";
    shortName = "Ruby";
    enableFeatureFreezePing = true;
  };

  rust = {
    members = [
      figsoda
      mic92
      tjni
      winter
      zowoq
    ];
    githubTeams = [
      "rust"
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
    members = [ ];
    scope = "Maintain Sphinx related packages.";
    shortName = "Sphinx";
  };

  serokell = {
    # Verify additions by approval of an already existing member of the team.
    members = [
      balsoft
    ];
    scope = "Group registration for Serokell employees who collectively maintain packages.";
    shortName = "Serokell employees";
  };

  steam = {
    members = [
      atemu
      eclairevoyant
      jonringer
      k900
      mkg20001
    ];
    scope = "Maintain steam module and packages";
    shortName = "Steam";
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
      mic92
    ];
    scope = "coqui-ai TTS (formerly Mozilla TTS) and leaf packages";
    shortName = "coqui-ai TTS";
  };

  vim = {
    members = [
      figsoda
      jonringer
      softinio
      teto
    ];
    scope = "Maintain the vim and neovim text editors and related packages.";
    shortName = "Vim/Neovim";
  };

  wdz = {
    members = [
      n0emis
      vidister
      johannwagner
      yuka
    ];
    scope = "Group registration for WDZ GmbH team members who collectively maintain packages.";
    shortName = "WDZ GmbH";
  };

  xfce = {
    members = [
      bobby285271
      romildo
      muscaln
    ];
    scope = "Maintain Xfce desktop environment and related packages.";
    shortName = "Xfce";
    enableFeatureFreezePing = true;
  };

  zig = {
    members = [
      AndersonTorres
      figsoda
    ];
    scope = "Maintain the Zig compiler toolchain and nixpkgs integration.";
    shortName = "Zig";
    enableFeatureFreezePing = true;
  };
}
