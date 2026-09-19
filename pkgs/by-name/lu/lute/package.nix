{
  lib,
  stdenv,
  callPackage,
  fetchFromGitHub,
  cmake,
  ninja,
  gitMinimal,
  openssl,
  curlFull,
  libuv,
  libsodium,
  zlib,
  writableTmpDirAsHomeHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "lute";
  version = "1.0.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "luau-lang";
    repo = "lute";
    tag = "v${finalAttrs.version}";
    hash = "sha256-g52fa/dQ4/Fk+NwbckrPtSkEjjql/+EU3tHsiV4jH40=";
  };

  env = {
    # to get ninja to print logs without being verbose
    TERM = "dumb";
  };

  nativeBuildInputs = [
    cmake
    ninja

    # Luthier invokes git to get git's version
    gitMinimal
  ];

  buildInputs = [
    curlFull # for websocket support
    openssl
    libuv
    libsodium
    zlib
  ];

  patches = [
    ./dont-build-dependencies.patch
    ./rename-link-libraries.patch
    ./rename-crypto-symbols.patch
  ];

  deps = callPackage ./deps.nix { };

  preConfigure = ''
    rm -rf extern
    cp -r $deps extern

    # Below copied from tools/bootstrap.sh from upstream Lute

    # place empty versions of the standard library
    mkdir -p lute/std/src/generated
    cp ./tools/templates/std_impl.cpp ./lute/std/src/generated/modules.cpp
    cp ./tools/templates/std_header.h ./lute/std/src/generated/modules.h

    # place empty versions of the luau-based lute subcommands for the cli
    mkdir -p lute/cli/generated
    cp ./tools/templates/cli_impl.cpp ./lute/cli/generated/commands.cpp
    cp ./tools/templates/cli_header.h ./lute/cli/generated/commands.h

    # place empty versions of the batteries library
    mkdir -p lute/batteries/generated
    cp ./tools/templates/batteries_impl.cpp ./lute/batteries/generated/batteries.cpp
    cp ./tools/templates/batteries_header.h ./lute/batteries/generated/batteries.h

    # place empty versions of the lute definitions
    mkdir -p lute/definitions/src/generated
    cp ./tools/templates/definitions_impl.cpp ./lute/definitions/src/generated/modules.cpp
    cp ./tools/templates/definitions_header.h ./lute/definitions/src/generated/modules.h
  '';

  cmakeFlags = [
    "-GNinja"
  ];

  buildPhase = ''
    runHook preBuild

    # bootstrap lute0
    ninja lute/cli/lute

    # generate Luau code
    pushd ..
    build/lute/cli/lute tools/luthier.luau generate
    popd

    # build final lute
    ninja lute/cli/lute

    runHook postBuild
  '';

  doCheck = true;
  nativeCheckInputs = [ writableTmpDirAsHomeHook ];
  checkPhase = ''
    runHook preCheck

    ninja tests/lute-tests

    # the doctests and Standard Library tests have to be run from lute source root
    pushd ..
    build/tests/lute-tests
    build/lute/cli/lute test
    popd

    runHook postCheck
  '';

  installPhase = ''
    install -Dm555 -t $out/bin lute/cli/lute

    mkdir -p $out/share
    cp -r ../batteries $out/share
  '';

  passthru.updateScript = ./update.nu;

  meta = {
    description = "Standalone Luau runtime for general-purpose programming";
    homepage = "https://lute.luau.org";
    changelog = "https://github.com/luau-lang/lute/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ b5e596 ];
    mainProgram = "lute";
    platforms = lib.platforms.all;
  };
})
