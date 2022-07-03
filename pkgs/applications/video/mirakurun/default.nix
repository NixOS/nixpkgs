# NOTE: Mirakurun is packaged outside of nodePackages because Node2nix can't
# handle one of its subdependencies. See below link for details.
#
# https://github.com/Chinachu/node-aribts/blob/af84dbbbd81ea80b946e538083b64b5b2dc7e8f2/package.json#L26

{ lib
, stdenvNoCC
, bash
, fetchFromGitHub
, gitUpdater
, jq
, makeWrapper
, mkYarnPackage
, which
, writers
, v4l-utils
, yarn
, yarn2nix
}:

stdenvNoCC.mkDerivation rec {
  pname = "mirakurun";
  version = "3.8.0";

  src = fetchFromGitHub {
    owner = "Chinachu";
    repo = "Mirakurun";
    rev = version;
    sha256 = "1fmzi3jc3havvpc1kz5z16k52lnrsmc3b5yqyxc7i911gqyjsxzr";
  };

  nativeBuildInputs = [ makeWrapper ];

  mirakurun = mkYarnPackage rec {
    name = "${pname}-${version}";
    inherit version src;

    yarnNix = ./yarn.nix;
    yarnLock = ./yarn.lock;
    packageJSON = ./package.json;

    patches = [
      # NOTE: fixes for hardcoded paths and assumptions about filesystem
      # permissions
      ./nix-filesystem.patch
    ];

    buildPhase = ''
      yarn --offline build
    '';

    distPhase = "true";
  };

  installPhase =
    let
      runtimeDeps = [ bash which v4l-utils ];
    in
    ''
      mkdir -p $out/bin

      makeWrapper ${mirakurun}/bin/mirakurun-epgdump $out/bin/mirakurun-epgdump \
        --chdir "${mirakurun}/libexec/mirakurun/node_modules/mirakurun" \
        --prefix PATH : ${lib.makeBinPath runtimeDeps}

      # XXX: The original mirakurun command uses PM2 to manage the Mirakurun
      # server.  However, we invoke the server directly and let systemd
      # manage it to avoid complication. This is okay since no features
      # unique to PM2 is currently being used.
      makeWrapper ${yarn}/bin/yarn $out/bin/mirakurun-start \
        --add-flags "start" \
        --chdir "${mirakurun}/libexec/mirakurun/node_modules/mirakurun" \
        --prefix PATH : ${lib.makeBinPath runtimeDeps}
    '';

  passthru.updateScript = import ./update.nix {
    inherit lib;
    inherit (src.meta) homepage;
    inherit
      pname
      version
      gitUpdater
      writers
      jq
      yarn
      yarn2nix;
  };

  meta = {
    inherit (mirakurun.meta) description platforms;
    maintainers = with lib.maintainers; [ midchildan ];
  };
}
