{ branch ? "mainline"
, qt6Packages
, fetchFromGitHub
, fetchgit
, fetchurl
, fetchzip
, runCommand
, gnutar
}:

let
  sources = import ./sources.nix;

  compat-list = fetchurl {
    name = "yuzu-compat-list";
    url = "https://raw.githubusercontent.com/flathub/org.yuzu_emu.yuzu/${sources.compatList.rev}/compatibility_list.json";
    hash = sources.compatList.hash;
  };

  mainlineSrc = fetchFromGitHub {
    owner = "yuzu-emu";
    repo = "yuzu-mainline";
    rev = "mainline-0-${sources.mainline.version}";
    hash = sources.mainline.hash;
    fetchSubmodules = true;
  };

  # The mirror repo for early access builds is missing submodule info,
  # but the Windows distributions include a source tarball, which in turn
  # includes the full git metadata. So, grab that and rehydrate it.
  # This has the unfortunate side effect of requiring two FODs, one
  # for the Windows download and one for the full repo with submodules.
  eaZip = fetchzip {
    name = "yuzu-ea-windows-dist";
    url = "https://github.com/pineappleEA/pineapple-src/releases/download/EA-${sources.ea.version}/Windows-Yuzu-EA-${sources.ea.version}.zip";
    hash = sources.ea.distHash;
  };

  eaGitSrc = runCommand "yuzu-ea-dist-unpacked" {
    src = eaZip;
    nativeBuildInputs = [ gnutar ];
  }
  ''
    mkdir $out
    tar xf $src/*.tar.xz --directory=$out --strip-components=1
  '';

  eaSrcRehydrated = fetchgit {
    url = eaGitSrc;
    fetchSubmodules = true;
    hash = sources.ea.fullHash;
  };

in {
  mainline = qt6Packages.callPackage ./generic.nix {
    branch = "mainline";
    version = sources.mainline.version;
    src = mainlineSrc;
    inherit compat-list;
  };

  early-access = qt6Packages.callPackage ./generic.nix {
    branch = "early-access";
    version = sources.ea.version;
    src = eaSrcRehydrated;
    inherit compat-list;
  };
}.${branch}
