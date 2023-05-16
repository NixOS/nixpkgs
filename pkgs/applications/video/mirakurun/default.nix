<<<<<<< HEAD
{ lib
, stdenv
, bash
, buildNpmPackage
, fetchFromGitHub
, installShellFiles
, makeWrapper
, nodejs
, substituteAll
, v4l-utils
, which
}:

buildNpmPackage rec {
  pname = "mirakurun";
  version = "3.9.0-rc.4";
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Chinachu";
    repo = "Mirakurun";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-Qg+wET5H9t3Mv2Hv0iT/C85/SEaQ+BHSBL3JjMQW5+Q=";
  };

  patches = [
    # NOTE: fixes for hardcoded paths and assumptions about filesystem
    # permissions
    ./nix-filesystem.patch
  ];

  npmDepsHash = "sha256-e7m7xb7p1SBzLAyQ82TTR/qLXv4lRm37x0JJPWYYGvI=";

  nativeBuildInputs = [ installShellFiles makeWrapper ];

  # workaround for https://github.com/webpack/webpack/issues/14532
  NODE_OPTIONS = "--openssl-legacy-provider";

  postInstall =
    let
      runtimeDeps = [
        bash
        nodejs
        which
      ] ++ lib.optionals stdenv.isLinux [ v4l-utils ];
      crc32Patch = substituteAll {
        src = ./fix-musl-detection.patch;
        isMusl = if stdenv.hostPlatform.isMusl then "true" else "false";
      };
    in
    ''
      sed 's/@DESCRIPTION@/${meta.description}/g' ${./mirakurun.1} > mirakurun.1
      installManPage mirakurun.1

      wrapProgram $out/bin/mirakurun-epgdump \
=======
    sha256 = "1fmzi3jc3havvpc1kz5z16k52lnrsmc3b5yqyxc7i911gqyjsxzr";
  };

  nativeBuildInputs = [ makeWrapper ];

  mirakurun = mkYarnPackage rec {
    name = "${pname}-${version}";
    inherit version src;

    yarnNix = ./yarn.nix;
    yarnLock = ./yarn.lock;
    packageJSON = ./package.json;

    # workaround for https://github.com/webpack/webpack/issues/14532
    NODE_OPTIONS = "--openssl-legacy-provider";

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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        --prefix PATH : ${lib.makeBinPath runtimeDeps}

      # XXX: The original mirakurun command uses PM2 to manage the Mirakurun
      # server.  However, we invoke the server directly and let systemd
      # manage it to avoid complication. This is okay since no features
      # unique to PM2 is currently being used.
<<<<<<< HEAD
      makeWrapper ${nodejs}/bin/npm $out/bin/mirakurun \
        --chdir "$out/lib/node_modules/mirakurun" \
        --prefix PATH : ${lib.makeBinPath runtimeDeps}

      pushd $out/lib/node_modules/mirakurun/node_modules/@node-rs/crc32
      patch -p3 < ${crc32Patch}
      popd
    '';

  meta = with lib; {
    description = "Resource manager for TV tuners.";
=======
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

  meta = with lib; {
    inherit (mirakurun.meta) description platforms;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.asl20;
    maintainers = with maintainers; [ midchildan ];
  };
}
