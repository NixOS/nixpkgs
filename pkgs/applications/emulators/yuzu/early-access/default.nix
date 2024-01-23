{ mainline, fetchzip, fetchgit, runCommand, gnutar }:
# The mirror repo for early access builds is missing submodule info,
# but the Windows distributions include a source tarball, which in turn
# includes the full git metadata. So, grab that and rehydrate it.
# This has the unfortunate side effect of requiring two FODs, one
# for the Windows download and one for the full repo with submodules.
let
  sources = import ./sources.nix;

  zip = fetchzip {
    name = "yuzu-ea-windows-dist";
    url = "https://github.com/pineappleEA/pineapple-src/releases/download/EA-${sources.version}/Windows-Yuzu-EA-${sources.version}.zip";
    hash = sources.distHash;
  };

  gitSrc = runCommand "yuzu-ea-dist-unpacked" {
    src = zip;
    nativeBuildInputs = [ gnutar ];
  }
  ''
    mkdir $out
    tar xf $src/*.tar.xz --directory=$out --strip-components=1
  '';

  rehydratedSrc = fetchgit {
    url = gitSrc;
    fetchSubmodules = true;
    hash = sources.fullHash;
  };
in mainline.overrideAttrs(old: {
  pname = "yuzu-early-access";
  version = sources.version;
  src = rehydratedSrc;
  passthru.updateScript = ./update.sh;
  meta = old.meta // { description = old.meta.description + " - early access branch"; };
})
