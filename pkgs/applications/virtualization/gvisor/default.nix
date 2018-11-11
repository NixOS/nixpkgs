{
  stdenv
, pkgs
, lib
, fetchFromGitHub
, cacert
, symlinks
, writeScript
, callPackage

, coreutils
, bash
, bazel
, git
, go
, python
, removeReferencesTo
}:

let

  # Bazel command we run.
  bazelCmd = "USER=nix bazel";

  # All dependency repositories that we fetch through Nix.
  repos = import ./repositories.nix {
    inherit (pkgs) fetchFromGitHub fetchgit fetchurl fetchzip buildGoPackage unzip;
  };

  # Command-line args to use above repositories.
  reposArgs = lib.mapAttrsToList (name: value: "--override_repository=${name}=${value}") repos;

in

stdenv.mkDerivation rec {
  name = "gvisor-${version}";
  version = "2018-11-10";

  src = fetchFromGitHub {
    owner = "google";
    repo  = "gvisor";
    rev   = "d97ccfa346d23d99dcbe634a10fa5d81b089100d";
    sha256 = "1x921qjxg041vghk4ypklqvcbpw2xs42bfah1k80g4ids29l1qyi";
  };

  nativeBuildInputs = [ bazel go python ];

  patchPhase = ''
    sed -i \
      's|go_register_toolchains(go_version="1.11.2")|go_register_toolchains(go_version="host")|g' \
      WORKSPACE
    find . -name '*.sh' -exec \
      sed -i 's|#!/bin/bash|#!/bin/sh|g' {} \;
  '';

  buildPhase = ''
    export TEST_TMPDIR=$PWD/bazel_root_dir
    mkdir -p "$TEST_TMPDIR"

    # Actually run the build
    ${bazelCmd} build \
      ${lib.escapeShellArgs reposArgs} \
      //runsc:runsc
  '';

  # TODO: use build event protocol(?) in order to find the right output file,
  # if we expand the set of supported platforms
  installPhase = ''
    install -Dm755 ./bazel-bin/runsc/linux_amd64_pure_stripped/runsc $out/bin/runsc
  '';

  meta = with stdenv.lib; {
    description = "Container Runtime Sandbox";
    homepage = https://github.com/google/gvisor;
    license = licenses.asl20;
    maintainers = with maintainers; [ andrew-d ];
    platforms = [ "x86_64-linux" ];
  };
}
