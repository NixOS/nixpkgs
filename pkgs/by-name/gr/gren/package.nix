{
  stdenv,
  lib,
  makeWrapper,
  fetchurl,
  nodejs,
  haskellPackages,
  versionCheckHook,
}:

let
  backendPkg = (haskellPackages.callPackage ./generated-backend-package.nix { }).overrideScope (
    final: prev: {
      ansi-wl-pprint = final.ansi-wl-pprint_0_6_9;
    }
  );

  npmPkgLock = builtins.fromJSON (builtins.readFile ./package-lock.json);

  # Download all packages that end up in node_modules so they can be
  # pulled from cache in the build phase when we are sandboxed.
  gren = fetchurl {
    url = npmPkgLock.packages.${"node_modules/gren-lang"}.resolved;
    hash = npmPkgLock.packages.${"node_modules/gren-lang"}.integrity;
  };

  postject = fetchurl {
    url = npmPkgLock.packages.${"node_modules/postject"}.resolved;
    hash = npmPkgLock.packages.${"node_modules/postject"}.integrity;
  };

  commander = fetchurl {
    url = npmPkgLock.packages.${"node_modules/commander"}.resolved;
    hash = npmPkgLock.packages.${"node_modules/commander"}.integrity;
  };
in
stdenv.mkDerivation {
  src = ./.;
  pname = "gren";
  version = npmPkgLock.packages.${"node_modules/gren-lang"}.version;

  buildInputs = [
    nodejs
    makeWrapper
  ];

  buildPhase = ''
    export HOME=$PWD/.home
    export npm_config_cache=$PWD/.npm

    npm cache add "${gren}"
    npm cache add "${postject}"
    npm cache add "${commander}"
    npm ci
  '';

  installPhase = ''
    mkdir -p $out/node_modules
    cp -r $src/node_modules/. $out/node_modules

    mkdir -p $out/bin
    ln -s $out/node_modules/.bin/* $out/bin

    wrapProgram $out/bin/gren \
      --set GREN_BIN ${lib.makeBinPath [ backendPkg ]}/gren
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/gren";
  versionCheckProgramArg = "--version";

  passthru = {
    updateScript = "./update.sh";
  };

  meta = {
    maintainers = with lib.maintainers; [
      robinheghan
    ];
  };
}
