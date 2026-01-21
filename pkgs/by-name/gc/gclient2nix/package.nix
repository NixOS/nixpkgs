{
  lib,
  python3,
  runCommand,
  makeWrapper,
  fetchgit,
  nurl,
  writers,
  callPackage,
  fetchFromGitiles,
  fetchFromGitHub,
  buildPackages,
}:

let
  fetchers = {
    inherit fetchgit fetchFromGitiles fetchFromGitHub;
  };

  importGclientDeps =
    depsAttrsOrFile:
    let
      depsAttrs = if lib.isAttrs depsAttrsOrFile then depsAttrsOrFile else lib.importJSON depsAttrsOrFile;
      fetchdep = dep: fetchers.${dep.fetcher} dep.args;
      fetchedDeps = lib.mapAttrs (_name: fetchdep) depsAttrs;
      manifestContents = lib.mapAttrs (_: dep: {
        path = dep;
      }) fetchedDeps;
      manifest = writers.writeJSON "gclient-manifest.json" manifestContents;
    in
    manifestContents
    // {
      inherit manifest;
      __toString = _: manifest;
    };

  gclientUnpackHook = callPackage (
    {
      lib,
      makeSetupHook,
      jq,
    }:

    makeSetupHook {
      name = "gclient-unpack-hook";
      substitutions = {
        jq = lib.getExe buildPackages.jq;
      };
    } ./gclient-unpack-hook.sh
  ) { };

  python = python3.withPackages (
    ps: with ps; [
      joblib
      platformdirs
      click
      click-log
    ]
  );

in

runCommand "gclient2nix"
  {
    nativeBuildInputs = [ makeWrapper ];
    buildInputs = [ python ];

    # substitutions
    depot_tools_checkout = fetchgit {
      url = "https://chromium.googlesource.com/chromium/tools/depot_tools";
      rev = "fa63ec7437108dcb3a611c6a6c5f3d96771e9581";
      hash = "sha256-hRIwhIdRF2GbyXbpOdi/lla+/XYM+gKosoK+T+kYYu0=";
    };

    passthru = {
      inherit fetchers importGclientDeps gclientUnpackHook;
    };
  }
  ''
    mkdir -p $out/bin
    substituteAll ${./gclient2nix.py} $out/bin/gclient2nix
    chmod u+x $out/bin/gclient2nix
    patchShebangs $out/bin/gclient2nix
    wrapProgram $out/bin/gclient2nix --set PATH "${lib.makeBinPath [ nurl ]}"
  ''
