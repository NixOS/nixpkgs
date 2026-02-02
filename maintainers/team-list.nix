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

  cockpit = {
    members = [
      alexandru0-dev
      andre4ik3
      lucasew
    ];
    scope = "Maintain Cockpit and official plugins by the Cockpit project.";
    shortName = "Cockpit";
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

  cuda = {
    github = "cuda-maintainers";
  };

  danklinux = {
    members = [
      luckshiba
      marcusramberg
    ];
    scope = "Maintain DankMaterialShell and related packages and modules from Dank Linux.";
    shortName = "Dank Linux";
  };

  darwin = {
    github = "darwin-core";
    enableFeatureFreezePing = true;
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

  forgejo = {
    members = [
      adamcstephens
      bendlas
      christoph-heiss
      emilylange
      marie
      pyrox0
      tebriel
    ];
    scope = "Maintain the Forgejo code forge, packages and modules.";
    shortName = "Forgejo";
  };

  formatter = {
    github = "nix-formatting";
  };

  freedesktop = {
    github = "freedesktop";
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
      gabyx
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

  minimal-bootstrap = {
    members = [
      alejandrosame
      aleksi
      artturin
      emilytrau
      ericson2314
      jk
      pyrox0
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
      phanirithvij
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

  # keep in-sync with ci/OWNERS
  nix = {
    members = [
      artturin
      ericson2314
      lovesegfault
      mic92
      philiptaron
      roberth
      tomberek
      xokdvium
    ];
    scope = "Maintain the packaging for the Nix package manager itself.";
    shortName = "Nix packaging";
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
