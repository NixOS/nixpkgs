{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  gitMinimal,
  writableTmpDirAsHomeHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "lute";
  version = "1.0.0";

  sourceRoot = ".";
  strictDeps = true;
  __structuredAttrs = true;

  # We use multiple sources instead of linkFarm or other solutions
  # because the dependencies need to be writable during build
  srcs = [
    ###_SOURCES_START_###
    (fetchFromGitHub {
      owner = "luau-lang";
      repo = "lute";
      tag = "v${finalAttrs.version}";
      hash = "sha256-g52fa/dQ4/Fk+NwbckrPtSkEjjql/+EU3tHsiV4jH40=";
      name = "lute";
    })
    (fetchFromGitHub {
      owner = "google";
      repo = "boringssl";
      rev = "2b44a3701a4788e1ef866ddc7f143060a3d196c9";
      hash = "sha256-/GZutq286F3gwQ3UhYjuR20bXzbqo4FxiC7E0yt5T60=";
      name = "boringssl";
    })
    (fetchFromGitHub {
      owner = "curl";
      repo = "curl";
      rev = "1c3149881769e7bd79b072e48374e4c2b3678b2f";
      hash = "sha256-huAGWNm2rYBmgzUuYQ21IYp2skyQECelEkXPMBJY3cE=";
      name = "curl";
    })
    (fetchFromGitHub {
      owner = "jedisct1";
      repo = "libsodium";
      rev = "9511c982fb1d046470a8b42aa36556cdb7da15de";
      hash = "sha256-ZPVzKJZRglZT2EJKqdBu94I4TRrF5sujSglUR64ApWA=";
      name = "libsodium";
    })
    (fetchFromGitHub {
      owner = "libuv";
      repo = "libuv";
      rev = "8fb9cb919489a48880680a56efecff6a7dfb4504";
      hash = "sha256-1Z/zf4qZYDM5upHdRtc1HGpHaGTRHm147azJZ0pT5pU=";
      name = "libuv";
    })
    (fetchFromGitHub {
      owner = "luau-lang";
      repo = "luau";
      rev = "4ca11dbc3b31ddf27ee8ec1ab6c036676de9f240";
      hash = "sha256-nfXJ16zkw9snA6dByPbP+OntPC4qXq5DK9ZnN5pvV98=";
      name = "luau";
    })
    (fetchFromGitHub {
      owner = "uNetworking";
      repo = "uSockets";
      rev = "833497e8e0988f7fd8d33cd4f6f36056c68d225d";
      hash = "sha256-ZlyY2X0aDdjfV0zjcecOLaozwp1crDibx6GBbUnDyAk=";
      name = "uSockets";
    })
    (fetchFromGitHub {
      owner = "uNetworking";
      repo = "uWebSockets";
      rev = "c445faa38125bf782eed3fec97f83b4733c7fb91";
      hash = "sha256-BEArW6TILz1Z39rjkge1PTz3defKwgITO6nBpyS13b8=";
      name = "uWebSockets";
    })
    (fetchFromGitHub {
      owner = "madler";
      repo = "zlib";
      rev = "51b7f2abdade71cd9bb0e7a373ef2610ec6f9daf";
      hash = "sha256-TkPLWSN5QcPlL9D0kc/yhH0/puE9bFND24aj5NVDKYs=";
      name = "zlib";
    })
    ###_SOURCES_END_###
  ];

  env = {
    # to get ninja to print logs without being verbose
    TERM = "dumb";
  };

  nativeBuildInputs = [
    cmake
    ninja

    # Luthier invokes git to fetch version
    gitMinimal
  ];

  patches =
    (lib.optional stdenv.cc.isGNU ./boringssl-disable-werror-gnu.patch)
    ++ (lib.optional stdenv.cc.isClang ./boringssl-disable-werror-clang.patch);

  preConfigure = ''
    rm -rf lute/extern/*
    mv libsodium libuv zlib curl luau boringssl uSockets uWebSockets lute/extern
    cd lute

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
  ]
  # required for https
  ++ (lib.optionals (!stdenv.hostPlatform.isDarwin) [
    "-DCURL_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt"
  ]);

  buildPhase = ''
    runHook preBuild

    # boostrap lute0
    ninja lute/cli/lute

    # generate Luau code
    pushd ..
    $OLDPWD/lute/cli/lute tools/luthier.luau generate
    popd

    # build final lute
    ninja lute/cli/lute

    runHook postBuild
  '';

  doCheck = true;
  nativeCheckInputs = [ writableTmpDirAsHomeHook ];
  checkPhase = ''
    runHook preCheck

    # build and run doctests
    # NOTE: the lute-tests binary has to be run from lute source root
    ninja tests/lute-tests
    pushd ..
    $OLDPWD/tests/lute-tests
    popd

    # run the Standard Library tests
    pushd ..
    $OLDPWD/lute/cli/lute test
    popd

    runHook postCheck
  '';

  installPhase = ''
    install -Dm555 -t $out/bin lute/cli/lute

    mkdir -p $out/lib
    cp -r ../batteries $out/lib
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
