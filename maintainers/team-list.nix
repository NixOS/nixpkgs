/*
  List of maintainer teams.
    name = {
      members = [ maintainer1 maintainer2 ];
      scope = "Maintain foo packages.";
      shortName = "foo";
      enableFeatureFreezePing = true;
      github = "my-subsystem";
    };

  where

  - `members` is the list of maintainers belonging to the group,
  - `scope` describes the scope of the group.
  - `shortName` short human-readable name
  - `enableFeatureFreezePing` will ping this team during the Feature Freeze announcements on releases
    - There is limited mention capacity in a single post, so this should be reserved for critical components
      or larger ecosystems within nixpkgs.
  - `github` will ping the specified GitHub team and sync the `members`, `scope` and `shortName` fields from it
  - `githubId` will be set automatically based on `github`

  If `github` is specified and you'd like to be added to the team, contact one of the `githubMaintainers` of the team:

      nix eval -f lib teams.someTeam.githubMaintainers --json | jq

  More fields may be added in the future.

  When editing this file:
   * keep the list alphabetically sorted
   * test the validity of the format with:
       nix-build lib/tests/teams.nix
*/

{ lib }:
with lib.maintainers;
{
  # keep-sorted start case=no numeric=no block=yes newline_separated=yes
  acme = {
    members = [
      aanderse
      arianvp
      emily
      m1cr0man
    ];
    scope = "Maintain ACME-related packages and modules.";
    shortName = "ACME";
    enableFeatureFreezePing = true;
  };

  agda = {
    github = "agda";
  };

  android = {
    github = "android";
    enableFeatureFreezePing = true;
  };

  apm = {
    scope = "Team for packages maintained by employees of Akademie für Pflegeberufe und Management GmbH.";
    shortName = "apm employees";
    # Edits to this list should only be done by an already existing member.
    members = [
      DutchGerman
      friedow
    ];
  };

  apparmor = {
    scope = "AppArmor-related modules, userspace tool packages and profiles";
    shortName = "apparmor";
    members = [
      julm
      thoughtpolice
      grimmauld
    ];
  };

  bazel = {
    members = [
      mboes
      cbley
      olebedev
      groodt
      aherrmann
      ylecornec
      boltzmannrain
    ];
    scope = "Bazel build tool & related tools https://bazel.build/";
    shortName = "Bazel";
    enableFeatureFreezePing = true;
  };

  beam = {
    github = "beam";
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
      getchoo
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

  cachix = {
    # Verify additions to this team with at least one existing member of the team.
    members = [
      domenkozar
      sandydoo
    ];
    scope = "Group registration for packages maintained by Cachix.";
    shortName = "Cachix employees";
  };

  categorization = {
    github = "categorization";
  };

  ci = {
    github = "nixpkgs-ci";
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

  clevercloud = {
    members = [ floriansanderscc ];
    scope = "Maintain Clever Cloud related packages.";
    shortName = "CleverCloud";
  };

  cloudposse = {
    members = [ dudymas ];
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
      stepbrobd
    ];
    scope = "Maintain the Coq theorem prover and related packages.";
    shortName = "Coq";
    enableFeatureFreezePing = true;
  };

  cosmic = {
    github = "cosmic";
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

  ctrl-os = {
    # Existing members may approve additions.
    members = [
      blitz
      messemar
      flyfloh
    ];

    scope = "Team of Cyberus Technology employees that maintain packages relevant to CTRL-OS";
    shortName = "CTRL-OS";
  };

  cuda = {
    github = "cuda-maintainers";
  };

  cyberus = {
    # Verify additions by approval of an already existing member of the team.
    members = [
      xanderio
      snu
      e1mo
    ];
    scope = "Team for Cyberus Technology employees who collectively maintain packages.";
    shortName = "Cyberus Technology employees";
  };

  darwin = {
    github = "darwin-core";
    enableFeatureFreezePing = true;
  };

  deshaw = {
    # Verify additions to this team with at least one already existing member of the team.
    members = [
      de11n
      despsyched
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
    ];
    scope = "Group registration for packages maintained by Determinate Systems.";
    shortName = "Determinate Systems employees";
  };

  dhall = {
    members = [
      Gabriella439
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
    github = "documentation-team";
    enableFeatureFreezePing = true;
  };

  dotnet = {
    members = [
      mdarocha
      corngood
      ggg
      raphaelr
      jamiemagee
      anpin
      meenzen
    ];
    scope = "Maintainers of the .NET build tools and packages";
    shortName = "dotnet";
  };

  electron = {
    members = [
      tomasajt
      yayayayaka
      teutat3s
    ];
    scope = "Maintainers of electron packages";
    shortName = "electron";
    enableFeatureFreezePing = true;
  };

  emacs = {
    members = [
      AndersonTorres
      adisbladis
      linj
      panchoh
    ];
    scope = "Maintain the Emacs editor and packages.";
    shortName = "Emacs";
  };

  enlightenment = {
    github = "enlightenment";
    enableFeatureFreezePing = true;
  };

  feel-co = {
    github = "feel-co";
  };

  flutter = {
    enableFeatureFreezePing = false;
    github = "flutter";
  };

  flyingcircus = {
    # Verify additions by approval of an already existing member of the team.
    members = [
      theuni
      dpausp
      frlan
      leona
      osnyx
    ];
    scope = "Team for Flying Circus employees who collectively maintain packages.";
    shortName = "Flying Circus employees";
  };

  formatter = {
    github = "nix-formatting";
  };

  freedesktop = {
    github = "freedesktop";
  };

  fslabs = {
    # Verify additions to this team with at least one already existing member of the team.
    members = [
      lpostula
      mockersf
      NthTensor
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
    github = "geospatial";
    enableFeatureFreezePing = true;
  };

  gitlab = {
    members = [
      krav
      leona
      talyz
      yayayayaka
    ];
    scope = "Maintain gitlab packages.";
    shortName = "gitlab";
  };

  gnome = {
    github = "gnome";
    enableFeatureFreezePing = true;
  };

  gnome-circle = {
    members = [
      aleksana
      getchoo
      michaelgrahamevans
    ];
    scope = "Maintain GNOME Circle applications.";
    shortName = "GNOME Circle";
  };

  golang = {
    github = "golang";
    enableFeatureFreezePing = true;
  };

  graalvm-ce = {
    members = [
      bandresen
      hlolli
      glittershark
      ericdallo
    ];
    scope = "Maintain GraalVM Community Edition packages.";
    shortName = "GraalVM-CE";
  };

  haskell = {
    github = "haskell";
    enableFeatureFreezePing = true;
  };

  helsinki-systems = {
    # Verify additions to this team with at least one already existing member of the team.
    members = [
      das_j
      conni2461
      helsinki-Jo
    ];
    scope = "Group registration for packages maintained by Helsinki Systems";
    shortName = "Helsinki Systems employees";
  };

  home-assistant = {
    members = [
      dotlambda
      fab
      hexa
    ];
    scope = "Maintain the Home Assistant ecosystem";
    shortName = "Home Assistant";
  };

  hyprland = {
    github = "hyprland";
    enableFeatureFreezePing = true;
  };

  infisical = {
    members = [ akhilmhdh ];
    scope = "Maintain Infisical";
    shortName = "Infisical";
  };

  iog = {
    members = [
      cleverca22
      disassembler
      manveru
    ];
    scope = "Input-Output Global employees, which maintain critical software";
    shortName = "Input-Output Global employees";
  };

  java = {
    github = "java";
    enableFeatureFreezePing = true;
  };

  jetbrains = {
    members = [
      leona
      theCapypara
      thiagokokada
      jamesward
    ];
    shortName = "Jetbrains";
    scope = "Maintainers of the Jetbrains IDEs in nixpkgs";
  };

  jitsi = {
    members = [
      novmar
      ryantm
      lassulus
      yayayayaka
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

  k3s = {
    github = "k3s";
  };

  kodi = {
    members = [
      aanderse
      cpages
      dschrempf
      kazenyuk
      minijackson
      peterhoeg
    ];
    scope = "Maintain Kodi and related packages.";
    shortName = "Kodi";
  };

  kubernetes = {
    github = "kubernetes";
  };

  libretro = {
    members = [
      aanderse
      thiagokokada
    ];
    scope = "Maintain Libretro, RetroArch and related packages.";
    shortName = "Libretro";
  };

  linux-kernel = {
    github = "linux-kernel";
  };

  lisp = {
    github = "lisp";
    enableFeatureFreezePing = true;
  };

  lix = {
    github = "lix-maintainers";
    enableFeatureFreezePing = true;
  };

  llvm = {
    github = "llvm";
    enableFeatureFreezePing = true;
  };

  lomiri = {
    members = [ OPNA2608 ];
    scope = "Maintain Lomiri desktop environment and related packages.";
    shortName = "Lomiri";
    enableFeatureFreezePing = true;
  };

  loongarch64 = {
    github = "loongarch64";
    enableFeatureFreezePing = true;
  };

  lua = {
    github = "lua";
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

  lumina = {
    github = "lumina";
    enableFeatureFreezePing = true;
  };

  lxc = {
    members = [
      aanderse
      adamcstephens
      megheaiulian
      mkg20001
    ];
    scope = "All things linuxcontainers. Incus, LXC, and related packages.";
    shortName = "lxc";
  };

  lxqt = {
    github = "lxqt";
    enableFeatureFreezePing = true;
  };

  marketing = {
    github = "marketing-team";
    enableFeatureFreezePing = true;
  };

  mate = {
    members = [
      bobby285271
      romildo
    ];
    scope = "Maintain Mate desktop environment and related packages.";
    shortName = "MATE";
    enableFeatureFreezePing = true;
  };

  matrix = {
    members = [
      ma27
      mguentner
      dandellion
      nickcao
      teutat3s
    ];
    scope = "Maintain the ecosystem around Matrix, a decentralized messenger.";
    shortName = "Matrix";
  };

  mercury = {
    members = [
      _9999years
      Gabriella439
      curran
      lf-
      jkachmar
    ];
    scope = "Group registry for packages maintained by Mercury";
    shortName = "Mercury Employees";
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

  module-system = {
    members = [
      infinisil
      roberth
    ];
    scope = "Maintain the Nixpkgs module system.";
    shortName = "Module system";
    enableFeatureFreezePing = true;
  };

  neovim = {
    github = "neovim";
  };

  nextcloud = {
    members = [
      bachp
      britter
      dotlambda
      ma27
      provokateurin
    ];
    scope = "Maintain Nextcloud, its tests and the integration of applications.";
    shortName = "Nextcloud";
    enableFeatureFreezePing = true;
  };

  ngi = {
    members = [
      eljamm
      ethancedwards8
      fricklerhandwerk
      OPNA2608
      prince213
      wegank
    ];
    scope = "Maintain NGI-supported software.";
    shortName = "NGI";
  };

  nim = {
    github = "nim";
    enableFeatureFreezePing = true;
  };

  # same as https://github.com/orgs/NixOS/teams/nix-team
  nix = {
    members = [
      eelco
      mic92
      tomberek
      roberth
      ericson2314
    ];
    scope = "Maintain the Nix package manager.";
    shortName = "Nix/nix-cli ecosystem";
    enableFeatureFreezePing = true;
  };

  nixos-rebuild = {
    members = [ thiagokokada ];
    scope = "Maintain nixos-rebuild(-ng).";
    shortName = "nixos-rebuild";
    enableFeatureFreezePing = true;
  };

  node = {
    members = [ winter ];
    scope = "Maintain Node.js runtimes and build tooling.";
    shortName = "Node.js";
    enableFeatureFreezePing = true;
  };

  ocaml = {
    github = "ocaml";
    enableFeatureFreezePing = true;
  };

  octodns = {
    members = [ anthonyroussel ];
    scope = "Maintain the ecosystem around OctoDNS";
    shortName = "OctoDNS";
  };

  openstack = {
    members = [
      SuperSandro2000
      anthonyroussel
      vinetos
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
    github = "pantheon";
    enableFeatureFreezePing = true;
  };

  perl = {
    members = [
      sgo
      marcusramberg
    ];
    scope = "Maintain the Perl interpreter and Perl packages.";
    shortName = "Perl";
    enableFeatureFreezePing = true;
  };

  php = {
    github = "php";
    enableFeatureFreezePing = true;
  };

  podman = {
    github = "podman";
  };

  postgres = {
    github = "postgres";
    enableFeatureFreezePing = true;
  };

  python = {
    members = [
      hexa
      natsukium
    ];
    scope = "Maintain the Python interpreter and related packages.";
    shortName = "Python";
    enableFeatureFreezePing = true;
  };

  qt-kde = {
    github = "qt-kde";
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

  rocm = {
    github = "rocm";
  };

  rust = {
    github = "rust";
    enableFeatureFreezePing = true;
  };

  sage = {
    members = [
      timokau
      raskin
      collares
    ];
    scope = "Maintain SageMath and the dependencies that are likely to break it.";
    shortName = "SageMath";
  };

  sdl = {
    github = "sdl";
    enableFeatureFreezePing = true;
  };

  secshell = {
    members = [
      felbinger
      juli0604
    ];
    scope = "Maintain packages and modules created by members of Secure Shell Networks.";
    shortName = "secshell";
  };

  serokell = {
    # Verify additions by approval of an already existing member of the team.
    members = [ balsoft ];
    scope = "Group registration for Serokell employees who collectively maintain packages.";
    shortName = "Serokell employees";
  };

  sphinx = {
    members = [ ];
    scope = "Maintain Sphinx related packages.";
    shortName = "Sphinx";
  };

  stdenv = {
    enableFeatureFreezePing = true;
    github = "stdenv";
  };

  steam = {
    members = [
      atemu
      k900
      mkg20001
    ];
    scope = "Maintain steam module and packages";
    shortName = "Steam";
  };

  stridtech = {
    # Verify additions by approval of an already existing member of the team
    members = [
      ulrikstrid
    ];
    scope = "Group registration for Strid Tech AB team members who collectively maintain packages";
    shortName = "StridTech";
  };

  swift = {
    members = [
      dduan
      samasaur
      stephank
      trepetti
    ];
    scope = "Maintain Swift compiler suite for NixOS.";
    shortName = "Swift";
  };

  systemd = {
    github = "systemd";
    enableFeatureFreezePing = true;
  };

  tests = {
    members = [ tfc ];
    scope = "Maintain the NixOS VM test runner.";
    shortName = "NixOS tests";
    enableFeatureFreezePing = true;
  };

  tts = {
    members = [ mic92 ];
    scope = "coqui-ai TTS (formerly Mozilla TTS) and leaf packages";
    shortName = "coqui-ai TTS";
  };

  uzinfocom = {
    members = [
      orzklv
      bahrom04
      bemeritus
      shakhzodkudratov
    ];
    scope = "Maintain Uzbek Linux state & community packages and modules.";
    shortName = "Uzinfocom Open Source";
  };

  wdz = {
    members = [
      n0emis
      johannwagner
      yuka
    ];
    scope = "Group registration for WDZ GmbH team members who collectively maintain packages.";
    shortName = "WDZ GmbH";
  };

  windows = {
    members = [
      RossSmyth
      eveeifyeve
      ericson2314
      puffnfresh
    ];
    scope = "Maintains the windows package set";
    shortName = "Windows";
  };

  xen = {
    enableFeatureFreezePing = true;
    github = "xen-project";
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
      RossComputerGuy
    ];
    scope = "Maintain the Zig compiler toolchain and nixpkgs integration.";
    shortName = "Zig";
    enableFeatureFreezePing = true;
  };
  # keep-sorted end
}
