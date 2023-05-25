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

  src = fetchFromGitHub {
    owner = "Chinachu";
    repo = "Mirakurun";
    rev = version;
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
        --prefix PATH : ${lib.makeBinPath runtimeDeps}

      # XXX: The original mirakurun command uses PM2 to manage the Mirakurun
      # server.  However, we invoke the server directly and let systemd
      # manage it to avoid complication. This is okay since no features
      # unique to PM2 is currently being used.
      makeWrapper ${nodejs}/bin/npm $out/bin/mirakurun \
        --chdir "$out/lib/node_modules/mirakurun" \
        --prefix PATH : ${lib.makeBinPath runtimeDeps}

      pushd $out/lib/node_modules/mirakurun/node_modules/@node-rs/crc32
      patch -p3 < ${crc32Patch}
      popd
    '';

  meta = with lib; {
    description = "Resource manager for TV tuners.";
    license = licenses.asl20;
    maintainers = with maintainers; [ midchildan ];
  };
}
