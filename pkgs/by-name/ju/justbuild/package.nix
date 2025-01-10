{
  gccStdenv,
  fetchFromGitHub,
  fetchurl,

  fmt_10,
  nlohmann_json,
  cli11,
  microsoft-gsl,
  libgit2,
  openssl,

  pkg-config,
  protobuf_25,
  grpc,
  pandoc,
  python3,
  unzip,
  wget,
  lib,
  jq,
  coreutils,

  curl,
  libarchive,
}:
let stdenv = gccStdenv;
in
stdenv.mkDerivation rec {
  pname = "justbuild";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "just-buildsystem";
    repo = "justbuild";
    rev = "v${version}";
    sha256 = "sha256-kv7HpDEYZml5uk06s8Cxt5rEpxaJBz9s+or6Od1q4Io=";
  };

  bazelapi = fetchurl {
    url = "https://github.com/bazelbuild/remote-apis/archive/e1fe21be4c9ae76269a5a63215bb3c72ed9ab3f0.tar.gz";
    sha256 = "7421abd5352ccf927c2050453a4dbfa1f7b1c7170ec3e8702b6fe2d39b8805fe";
  };

  googleapi = fetchurl {
    url = "https://github.com/googleapis/googleapis/archive/2f9af297c84c55c8b871ba4495e01ade42476c92.tar.gz";
    sha256 = "5bb6b0253ccf64b53d6c7249625a7e3f6c3bc6402abd52d3778bfa48258703a0";
  };

  nativeBuildInputs =
    [
      # Tools for the bootstrap process
      jq
      pkg-config
      python3
      unzip
      wget
      coreutils

      # Dependencies of just
      cli11
      # Using fmt 10 because this is the same version upstream currently
      # uses for bundled builds
      # For future updates: The currently used version can be found in the file
      # etc/repos.json: https://github.com/just-buildsystem/justbuild/blob/master/etc/repos.json
      # under the key .repositories.fmt
      fmt_10
      microsoft-gsl
      nlohmann_json

      # Dependencies of the compiled just-mr
      curl
      libarchive
    ];

  buildInputs = [
    grpc
    libgit2
    openssl
    protobuf_25
    python3
  ];

  postPatch = ''
    sed -ie 's|\./bin/just-mr.py|${python3}/bin/python3 ./bin/just-mr.py|' bin/bootstrap.py
    sed -ie 's|#!/usr/bin/env python3|#!${python3}/bin/python3|' bin/parallel-bootstrap-traverser.py
    jq '.repositories.protobuf.pkg_bootstrap.local_path = "${protobuf_25}"' etc/repos.json > etc/repos.json.patched
    mv etc/repos.json.patched etc/repos.json
    jq '.repositories.com_github_grpc_grpc.pkg_bootstrap.local_path = "${grpc}"' etc/repos.json > etc/repos.json.patched
    mv etc/repos.json.patched etc/repos.json
    jq '.unknown.PATH = []' etc/toolchain/CC/TARGETS > etc/toolchain/CC/TARGETS.patched
    mv etc/toolchain/CC/TARGETS.patched etc/toolchain/CC/TARGETS
  '' + lib.optionalString stdenv.isDarwin ''
    sed -ie 's|-Wl,-z,stack-size=8388608|-Wl,-stack_size,0x800000|' bin/bootstrap.py
  '';

  /* The build phase follows the bootstrap procedure that is explained in
     https://github.com/just-buildsystem/justbuild/blob/master/INSTALL.md

     The bootstrap of the just binary depends on two proto libraries, which are
     supplied as external distfiles.

     The microsoft-gsl library does not provide a pkg-config file, so one is
     created here. In case also the GNU Scientific Library would be used (which
     has also the pkg-config name gsl) this would cause a conflict. However, it
     is very unlikely that a build tool will ever depend on a GPL math library.

     The extra build flags (ADD_CFLAGS and ADD_CXXFLAGS) are only needed in the
     current version of just, the next release will contain a fix from upstream.
     https://github.com/just-buildsystem/justbuild/commit/5abcd4140a91236c7bda1c21ce69e76a28da7c8a

  */

  buildPhase = ''
    runHook preBuild

    mkdir .distfiles
    ln -s ${bazelapi} .distfiles/e1fe21be4c9ae76269a5a63215bb3c72ed9ab3f0.tar.gz
    ln -s ${googleapi} .distfiles/2f9af297c84c55c8b871ba4495e01ade42476c92.tar.gz

    mkdir .pkgconfig
    cat << __EOF__ > .pkgconfig/gsl.pc
    Name: gsl
    Version: n/a
    Description: n/a
    URL: n/a
    Cflags: -I${microsoft-gsl}/include
    __EOF__
    export PKG_CONFIG_PATH=`pwd`/.pkgconfig''${PKG_CONFIG_PATH:+:}$PKG_CONFIG_PATH

    # Bootstrap just
    export PACKAGE=YES
    export NON_LOCAL_DEPS='[ "google_apis", "bazel_remote_apis" ]'
    export JUST_BUILD_CONF=`echo $PATH | jq -R '{ ENV: { PATH: . }, "ADD_CXXFLAGS": ["-D__unix__", "-DFMT_HEADER_ONLY"], "ARCH": "'$(uname -m)'" }'`

    mkdir ../build
    python3 ./bin/bootstrap.py `pwd` ../build "`pwd`/.distfiles"

    # Build compiled just-mr
    ../build/out/bin/just install 'installed just-mr' -c ../build/build-conf.json -C ../build/repo-conf.json --output-dir ../build/out --local-build-root ../build/.just

    # convert man pages from Markdown to man
    find "./share/man" -name "*.md" -exec sh -c '${pandoc}/bin/pandoc --standalone --to man -o "''${0%.md}" "''${0}"' {} \;

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin"


    install -m 755 -Dt "$out/bin" "../build/out/bin/just"
    install -m 755 -Dt "$out/bin" "../build/out/bin/just-mr"
    install -m 755 -DT "bin/just-import-git.py" "$out/bin/just-import-git"
    install -m 755 -DT "bin/just-deduplicate-repos.py" "$out/bin/just-deduplicate-repos"

    mkdir -p "$out/share/bash-completion/completions"
    install -m 0644 ./share/just_complete.bash "$out/share/bash-completion/completions/just"

    mkdir -p "$out/share/man/"{man1,man5}
    install -m 0644 -t "$out/share/man/man1" ./share/man/*.1
    install -m 0644 -t "$out/share/man/man5" ./share/man/*.5

    runHook postInstall
  '';

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Generic build tool";
    homepage = "https://github.com/just-buildsystem/justbuild";
    license = licenses.asl20;
    maintainers = with maintainers; [clkamp];
  };
}
