/*
  List of maintainer teams.
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
with lib.maintainers;
{
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

  android = {
    members = [
      adrian-gierakowski
      hadilq
      johnrtitor
      numinit
      RossComputerGuy
    ];
    scope = "Maintain Android-related tooling in nixpkgs.";
    githubTeams = [ "android" ];
    shortName = "Android";
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
      adamcstephens
      ankhers
      Br1ght0ne
      DianaOlympos
      gleber
      happysalada
      minijackson
      yurrriq
    ];
    githubTeams = [ "beam" ];
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

  categorization = {
    members = [
      aleksana
      fgaz
      getpsyched
      lyndeno
      natsukium
      philiptaron
      pyrotelekinetic
      raskin
      sigmasquadron
      tomodachi94
    ];
    githubTeams = [ "categorization" ];
    scope = "Maintain the categorization system in Nixpkgs, per RFC 146. This team has authority over all categorization issues in Nixpkgs.";
    shortName = "Categorization";
  };

  ci = {
    members = [
      MattSturgeon
      mic92
      philiptaron
      wolfgangwalther
      zowoq
    ];
    githubTeams = [ "nixpkgs-ci" ];
    scope = "Maintain Nixpkgs' in-tree Continuous Integration, including GitHub Actions.";
    shortName = "CI";
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
    githubTeams = [ "CleverCloud" ];
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
    members = [
      a-kenji
      ahoneybun
      drakon64
      griffi-gh
      HeitorAugustoLN
      nyabinary
      pandapip1
      qyliss
      thefossguy
      michaelBelsanti
    ];
    githubTeams = [ "cosmic" ];
    shortName = "cosmic";
    scope = "Maintain the COSMIC DE and related packages.";
    enableFeatureFreezePing = true;
  };

  cuda = {
    members = [
      connorbaker
      prusnak
      samuela
      SomeoneSerge
    ];
    scope = "Maintain CUDA-enabled packages";
    shortName = "Cuda";
    githubTeams = [ "cuda-maintainers" ];
  };

  cyberus = {
    # Verify additions by approval of an already existing member of the team.
    members = [
      xanderio
      blitz
      snu
    ];
    scope = "Team for Cyberus Technology employees who collectively maintain packages.";
    shortName = "Cyberus Technology employees";
  };

  darwin = {
    members = [
      emily
      reckenrode
      toonn
    ];
    githubTeams = [ "darwin-core" ];
    scope = "Maintain core platform support and packages for macOS and other Apple platforms.";
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

  deepin = {
    members = [ wineee ];
    scope = "Maintain deepin desktop environment and related packages.";
    shortName = "DDE";
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
    members = [ ];
    githubTeams = [ "documentation-team" ];
    scope = "Maintain nixpkgs/NixOS documentation and tools for building it.";
    shortName = "Docs";
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
    members = [ romildo ];
    githubTeams = [ "enlightenment" ];
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
    members = [
      mkg20001
      RossComputerGuy
      FlafyDev
      hacker1024
    ];
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
    ];
    scope = "Team for Flying Circus employees who collectively maintain packages.";
    shortName = "Flying Circus employees";
  };

  formatter = {
    members = [
      piegames
      infinisil
      das_j
      _0x4A6F
      MattSturgeon
      jfly
      # Not in the maintainer list
      # Sereja313
    ];
    scope = "Nix formatting team: https://nixos.org/community/teams/formatting/";
    shortName = "Nix formatting team";
  };

  freedesktop = {
    members = [ jtojnar ];
    scope = "Maintain Freedesktop.org packages for graphical desktop.";
    shortName = "freedesktop.org packaging";
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
    members = [
      autra
      imincik
      l0b0
      nh2
      nialov
      sikmir
      willcohen
    ];
    githubTeams = [ "geospatial" ];
    scope = "Maintain geospatial, remote sensing and OpenStreetMap software.";
    shortName = "Geospatial";
    enableFeatureFreezePing = true;
  };

  gitlab = {
    members = [
      globin
      krav
      leona
      talyz
      yayayayaka
    ];
    scope = "Maintain gitlab packages.";
    shortName = "gitlab";
  };

  golang = {
    members = [
      kalbasit
      katexochen
      mic92
      zowoq
      qbit
      mfrw
    ];
    githubTeams = [ "golang" ];
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
    githubTeams = [ "gnome" ];
    scope = "Maintain GNOME desktop environment and platform.";
    shortName = "GNOME";
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
    members = [
      cdepillabout
      maralorn
      sternenseemann
      wolfgangwalther
    ];
    githubTeams = [ "haskell" ];
    scope = "Maintain Haskell packages and infrastructure.";
    shortName = "Haskell";
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
    members = [
      donovanglover
      fufexan
      johnrtitor
      khaneliman
      NotAShelf
    ];
    githubTeams = [ "hyprland" ];
    scope = "Maintain Hyprland compositor and ecosystem";
    shortName = "Hyprland";
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
    githubTeams = [ "java" ];
    members = [
      chayleaf
      fliegendewurst
      infinidoge
      tomodachi94
    ];
    shortName = "Java";
    scope = "Maintainers of the Nixpkgs Java ecosystem (JDK, JVM, Java, Gradle, Maven, Ant, and adjacent projects)";
    enableFeatureFreezePing = true;
  };

  jetbrains = {
    members = [
      edwtjo
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
      cleeyv
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
    githubTeams = [ "k3s" ];
    members = [
      euank
      frederictobiasc
      marcusramberg
      mic92
      rorosen
      wrmilling
      yajo
    ];
    scope = "Maintain K3s package, NixOS module, NixOS tests, update script";
    shortName = "K3s";
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
    ];
    scope = "Maintain Kodi and related packages.";
    shortName = "Kodi";
  };

  libretro = {
    members = [
      aanderse
      edwtjo
      hrdinka
      thiagokokada
    ];
    scope = "Maintain Libretro, RetroArch and related packages.";
    shortName = "Libretro";
  };

  linux-kernel = {
    members = [
      TredwellGit
      k900
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
    githubTeams = [ "lisp" ];
    scope = "Maintain the Lisp ecosystem.";
    shortName = "lisp";
    enableFeatureFreezePing = true;
  };

  llvm = {
    members = [
      dtzWill
      emily
      ericson2314
      lovek323
      qyliss
      RossComputerGuy
      rrbutani
      sternenseemann
    ];
    githubTeams = [ "llvm" ];
    scope = "Maintain LLVM package sets and related packages";
    shortName = "LLVM";
    enableFeatureFreezePing = true;
  };

  lomiri = {
    members = [ OPNA2608 ];
    scope = "Maintain Lomiri desktop environment and related packages.";
    shortName = "Lomiri";
    enableFeatureFreezePing = true;
  };

  loongarch64 = {
    members = [
      aleksana
      Cryolitia
      darkyzhou
      dramforever
      wegank
    ];
    githubTeams = [ "loongarch64" ];
    scope = "Maintain LoongArch64 related packages and code";
    shortName = "LoongArch64";
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
    githubTeams = [ "lua" ];
    scope = "Maintain the lua ecosystem.";
    shortName = "lua";
    enableFeatureFreezePing = true;
  };

  lumina = {
    members = [ romildo ];
    githubTeams = [ "lumina" ];
    scope = "Maintain lumina desktop environment and related packages.";
    shortName = "Lumina";
    enableFeatureFreezePing = true;
  };

  lxc = {
    members = [
      aanderse
      adamcstephens
      megheaiulian
      mkg20001
    ];
    scope = "All things linuxcontainers. LXC, Incus, LXD and related packages.";
    shortName = "lxc";
  };

  lxqt = {
    members = [ romildo ];
    githubTeams = [ "lxqt" ];
    scope = "Maintain LXQt desktop environment and related packages.";
    shortName = "LXQt";
    enableFeatureFreezePing = true;
  };

  marketing = {
    members = [
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
      curran
      lf-
      jkachmar
    ];
    scope = "Group registry for packages maintained by Mercury";
    shortName = "Mercury Employees";
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

  lix = {
    members = [
      raitobezarius
      qyriad
      _9999years
      lf-
      alois31
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

  neovim = {
    members = [
      GaetanLepage
      khaneliman
      mrcjkb
      perchun
    ];
    githubTeams = [ "neovim" ];
    scope = "Maintain the vim and neovim text editors and related packages.";
    shortName = "Vim/Neovim";
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
    members = [ alizter ];
    githubTeams = [ "ocaml" ];
    scope = "Maintain the OCaml compiler and package set.";
    shortName = "OCaml";
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
    members = [
      davidak
      bobby285271
    ];
    githubTeams = [ "pantheon" ];
    scope = "Maintain Pantheon desktop environment and platform.";
    shortName = "Pantheon";
    enableFeatureFreezePing = true;
  };

  perl = {
    members = [
      sgo
      marcusramberg
      zakame
    ];
    scope = "Maintain the Perl interpreter and Perl packages.";
    shortName = "Perl";
    enableFeatureFreezePing = true;
  };

  php = {
    members = [
      aanderse
      ma27
      piotrkwiecinski
      talyz
    ];
    githubTeams = [ "php" ];
    scope = "Maintain PHP related packages and extensions.";
    shortName = "PHP";
    enableFeatureFreezePing = true;
  };

  podman = {
    members = [
      saschagrunert
      vdemeester
    ];
    githubTeams = [ "podman" ];
    scope = "Maintain Podman and CRI-O related packages and modules.";
    shortName = "Podman";
  };

  postgres = {
    members = [
      thoughtpolice
      ma27
      wolfgangwalther
    ];
    scope = "Maintain the PostgreSQL package and plugins along with the NixOS module.";
    shortName = "PostgreSQL";
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
    members = [
      ilya-fedin
      k900
      LunNova
      mjm
      nickcao
      SuperSandro2000
      ttuegel
    ];
    githubTeams = [ "qt-kde" ];
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
    githubTeams = [ "nixos-release-managers" ];
    scope = "Manage the current nixpkgs/NixOS release.";
    shortName = "Release";
  };

  rocm = {
    members = [
      Flakebi
      GZGavinZhao
      LunNova
      mschwaig
    ];
    githubTeams = [ "rocm-maintainers" ];
    scope = "Maintain ROCm and related packages.";
    shortName = "ROCm";
  };

  ruby = {
    members = [ ];
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
    githubTeams = [ "rust" ];
    scope = "Maintain the Rust compiler toolchain and nixpkgs integration.";
    shortName = "Rust";
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
    members = [
      evythedemon
      grimmauld
      jansol
      marcin-serwin
      pbsds
    ];
    githubTeams = [ "SDL" ];
    scope = "Maintain core SDL libraries.";
    shortName = "SDL";
    enableFeatureFreezePing = true;
  };

  sphinx = {
    members = [ ];
    scope = "Maintain Sphinx related packages.";
    shortName = "Sphinx";
  };

  serokell = {
    # Verify additions by approval of an already existing member of the team.
    members = [ balsoft ];
    scope = "Group registration for Serokell employees who collectively maintain packages.";
    shortName = "Serokell employees";
  };

  stdenv = {
    members = [
      artturin
      emily
      ericson2314
      philiptaron
      reckenrode
      RossComputerGuy
    ];
    scope = "Maintain the standard environment and its surrounding logic.";
    shortName = "stdenv";
    enableFeatureFreezePing = true;
    githubTeams = [ "stdenv" ];
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
      stephank
      trepetti
      trundle
    ];
    scope = "Maintain Swift compiler suite for NixOS.";
    shortName = "Swift";
  };

  systemd = {
    members = [
      flokli
      arianvp
      elvishjerricco
      aanderse
      grimmauld
    ];
    githubTeams = [ "systemd" ];
    scope = "Maintain systemd for NixOS.";
    shortName = "systemd";
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

  wdz = {
    members = [
      n0emis
      johannwagner
      yuka
    ];
    scope = "Group registration for WDZ GmbH team members who collectively maintain packages.";
    shortName = "WDZ GmbH";
  };

  xen = {
    members = [
      hehongbo
      lach
      sigmasquadron
      rane
    ];
    scope = "Maintain the Xen Project Hypervisor and the related tooling ecosystem.";
    shortName = "Xen Project Hypervisor";
    enableFeatureFreezePing = true;
    githubTeams = [ "xen-project" ];
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
      figsoda
      RossComputerGuy
    ];
    scope = "Maintain the Zig compiler toolchain and nixpkgs integration.";
    shortName = "Zig";
    enableFeatureFreezePing = true;
  };
}
