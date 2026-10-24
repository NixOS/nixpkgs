{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  curl,
  tbox,
}:

let
  # Not packaged in nixpkgs; only its header and single source file are needed.
  isocline = fetchFromGitHub {
    owner = "daanx";
    repo = "isocline";
    tag = "v1.0.9";
    hash = "sha256-9hMvXa9+7XtB2pMQ3mQYccdM0wyscUooMpBwDoh1DiA=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "goldfish";
  version = "18.11.40";

  src = fetchFromGitHub {
    owner = "MoganLab";
    repo = "goldfish";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pySphM2cAT4rW/EmsnL54218uXRcGQ1IRB58wRqtsC4=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  buildInputs = [
    curl
    tbox
  ];

  # Upstream builds with xmake, which fetches its dependencies from the network
  # at configure time. Compile against the packaged tbox and curl instead, and
  # build the vendored cpr and the isocline sources directly.
  env.NIX_CFLAGS_COMPILE = toString [
    "-O2"
    "-DWITH_WARNINGS"
    "-DWITH_R7RS=1"
    "-DWITH_SYSTEM_EXTRAS=0"
    "-DHAVE_OVERFLOW_CHECKS=0"
    "-DGOLDFISH_WITH_REPL"
  ];

  preBuild = ''
    mkdir -p cpr_build/include/cpr

    cp -r 3rdparty/cpr/cpr cpr_build/include/
    cp -r 3rdparty/cpr/include/cpr/. cpr_build/include/cpr/
    cp 3rdparty/argh/argh.h cpr_build/include/
    cp ${isocline}/include/isocline.h cpr_build/include/

    # cpr normally generates its version header during the CMake configure step.
    sed \
      -e 's|''${cpr_VERSION}|1.11.1|' \
      -e 's|''${cpr_VERSION_MAJOR}|1|' \
      -e 's|''${cpr_VERSION_MINOR}|11|' \
      -e 's|''${cpr_VERSION_PATCH}|1|' \
      -e 's|''${cpr_VERSION_NUM}|0x010b01|' \
      3rdparty/cpr/cmake/cprver.h.in > cpr_build/include/cpr/cprver.h

    # isocline is built from its source directory, since isocline.c includes its
    # sibling sources.
    $CC $CFLAGS -std=c11 -I cpr_build/include -c ${isocline}/src/isocline.c \
      -o isocline.o

    # cpr requires C++17 and uses <filesystem>.
    for f in 3rdparty/cpr/cpr/*.cpp; do
      $CXX $CXXFLAGS -std=c++17 -I cpr_build/include -DCPR_ENABLE_SSL -c "$f" \
        -o "cpr_build/$(basename "$f" .cpp).o"
    done
  '';

  buildPhase = ''
    runHook preBuild

    for f in src/s7*.c; do
      echo "compiling $f"
      $CC $CFLAGS -std=c11 -c "$f" -o "''${f%.c}.o"
    done

    for f in src/*.cpp; do
      # goldfish_repl.cpp is a standalone REPL target for the web build and is
      # not part of the gf binary.
      if [ "$f" = src/goldfish_repl.cpp ]; then
        continue
      fi
      echo "compiling $f"
      $CXX $CXXFLAGS -std=c++17 -DGOLDFISH_ENABLE_HTTP -I cpr_build/include -c "$f" -o "''${f%.cpp}.o"
    done

    $CXX -o bin/gf src/*.o cpr_build/*.o isocline.o \
      $NIX_LDFLAGS -ltbox -lcurl -lpthread -lm

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 bin/gf $out/bin/gf

    # The interpreter locates its Scheme standard library in share/goldfish,
    # relative to its own location.
    mkdir -p $out/share/goldfish
    cp -r goldfish/scheme goldfish/srfi goldfish/liii -t $out/share/goldfish/
    cp gfproject.json node-rules.json -t $out/share/goldfish/
    cp -r tools -t $out/share/goldfish/

    runHook postInstall
  '';

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    # These tests spawn /bin/* or inspect /etc, which are unavailable in the
    # Nix sandbox.
    rm -rf \
      tests/liii/path \
      tests/liii/path-test.scm \
      tests/liii/subprocess \
      tests/liii/subprocess-test.scm

    ./bin/gf test tests/scheme
    ./bin/gf test tests/srfi
    ./bin/gf test tests/liii

    runHook postCheck
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/gf --version
    $out/bin/gf version | grep -F 'Goldfish Scheme ${finalAttrs.version}'

    # Check that the interpreter works and that the Scheme standard library is
    # found at its installed location, including the HTTP library, which is the
    # only part linking against libcurl.
    $out/bin/gf eval '(+ 1 2)' | grep -xF '3'
    $out/bin/gf eval '(begin (import (liii http)) (procedure? http-get))' | grep -xF '#t'

    # The isocline-based REPL is only built when GOLDFISH_WITH_REPL is defined.
    $out/bin/gf --help | grep -F 'Enter interactive REPL mode'

    runHook postInstallCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Scheme interpreter with a Python-like standard library";
    longDescription = ''
      Goldfish Scheme is an R7RS-small compatible Scheme interpreter built on
      top of the S7 Scheme engine. It ships a Python-like standard library,
      including modules for JSON, HTTP, subprocesses, hashing and Go-style
      concurrency, together with an interactive REPL.
    '';
    changelog = "https://github.com/MoganLab/goldfish/releases/tag/v${finalAttrs.version}";
    homepage = "https://github.com/MoganLab/goldfish";
    license = lib.licenses.asl20;
    mainProgram = "gf";
    maintainers = with lib.maintainers; [ elliot ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
