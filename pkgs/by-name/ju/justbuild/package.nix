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
  protobuf,
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

  nix-update-script,
  testers,
  justbuild,
}:
let
  stdenv = gccStdenv;
in
stdenv.mkDerivation rec {
  pname = "justbuild";
  version = "1.6.3";

  src = fetchFromGitHub {
    owner = "just-buildsystem";
    repo = "justbuild";
    rev = "refs/tags/v${version}";
    hash = "sha256-ZTwe6S0AH1yQt5mABtIeWuMbiVSKeOZWMFI26fthLsM=";
  };

  bazelapi = fetchurl {
    url = "https://github.com/bazelbuild/remote-apis/archive/9ef19c6b5fbf77d6dd9d84d75fbb5a20a6b62ef1.tar.gz";
    hash = "sha256-zPV1ObY0fOsKp+k+5Duf/xrrSW02zAl9qRjEo172WDk=";
  };

  googleapi = fetchurl {
    url = "https://github.com/googleapis/googleapis/archive/fe8ba054ad4f7eca946c2d14a63c3f07c0b586a0.tar.gz";
    hash = "sha256:1r33jj8yipxjgiarddcxr1yc5kmn98rwrjl9qxfx0fzn1bsg04q5";
  };

  nativeBuildInputs = [
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
    # etc/repos.in.json: https://github.com/just-buildsystem/justbuild/blob/master/etc/repos.in.json
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
    protobuf
    python3
  ];

  postPatch = ''
    sed -i -e 's|\./bin/just-mr.py|${python3}/bin/python3 ./bin/just-mr.py|' bin/bootstrap.py
    sed -i -e 's|#!/usr/bin/env python3|#!${python3}/bin/python3|' bin/parallel-bootstrap-traverser.py
    jq '.repositories.protobuf.pkg_bootstrap.local_path = "${protobuf}"' etc/repos.in.json > etc/repos.in.json.patched
    mv etc/repos.in.json.patched etc/repos.in.json
    jq '.repositories.com_github_grpc_grpc.pkg_bootstrap.local_path = "${grpc}"' etc/repos.in.json > etc/repos.in.json.patched
    mv etc/repos.in.json.patched etc/repos.in.json
    jq '.unknown.PATH = []' etc/toolchain/CC/TARGETS > etc/toolchain/CC/TARGETS.patched
    mv etc/toolchain/CC/TARGETS.patched etc/toolchain/CC/TARGETS
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    sed -i -e 's|-Wl,-z,stack-size=8388608|-Wl,-stack_size,0x800000|' bin/bootstrap.py
  '';

  /*
    The build phase follows the bootstrap procedure that is explained in
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
    ln -s ${bazelapi} .distfiles/9ef19c6b5fbf77d6dd9d84d75fbb5a20a6b62ef1.tar.gz
    ln -s ${googleapi} .distfiles/fe8ba054ad4f7eca946c2d14a63c3f07c0b586a0.tar.gz

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
    install -m 755 -DT "bin/just-lock.py" "$out/bin/just-lock"

    mkdir -p "$out/share/bash-completion/completions"
    install -m 0644 ./share/just_complete.bash "$out/share/bash-completion/completions/just"

    mkdir -p "$out/share/man/"{man1,man5}
    install -m 0644 -t "$out/share/man/man1" ./share/man/*.1
    install -m 0644 -t "$out/share/man/man5" ./share/man/*.5

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = justbuild;
      command = "just version";
      version = builtins.replaceStrings [ "." ] [ "," ] version;
    };
  };

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Generic build tool";
    homepage = "https://github.com/just-buildsystem/justbuild";
    changelog = "https://github.com/just-buildsystem/justbuild/releases/tag/v${version}";
    mainProgram = "just";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ clkamp ];
  };
}
