{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchFromSourcehut,
  callPackage,
  coreutils,
  curl,
  libarchive,
  libpkgconf,
  pkgconf,
  samurai,
  zlib,
  embedSamurai ? false,
  # docs
  buildDocs ? true,
  scdoc,
  # tests
  runTests ? false,
  gettext,
  muon,
  nasm,
  pkg-config,
  python3,
  writableTmpDirAsHomeHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "muon" + lib.optionalString embedSamurai "-embedded-samurai";
  version = "0.5.0";

  srcs = builtins.attrValues (lib.filterAttrs (_: v: v.use or true) finalAttrs.passthru.srcsAttrs);

  sourceRoot = "muon-src";

  outputs = [ "out" ] ++ lib.optionals buildDocs [ "man" ];

  nativeBuildInputs = [
    pkgconf
  ]
  ++ lib.optionals (!embedSamurai) [ samurai ]
  ++ lib.optionals buildDocs [
    scdoc
  ]
  ++ lib.optionals (buildDocs || finalAttrs.doCheck) [
    (python3.withPackages (ps: [ ps.pyyaml ]))
  ];

  buildInputs = [
    curl
    libarchive
    libpkgconf
    zlib
  ];

  strictDeps = true;

  postUnpack = ''
    for src in $srcs; do
      name=$(stripHash $src)

      # skip the main project, only move subprojects
      [ "$name" == "$sourceRoot" ] && continue

      cp -r "$name" "$sourceRoot/subprojects/$name"
      chmod +w -R "$sourceRoot/subprojects/$name"
      rm "$sourceRoot/subprojects/$name.wrap"
    done
  '';

  patches = [ ./darwin-clang.patch ];

  postPatch = ''
    find subprojects -name "*.py" -exec chmod +x {} \;
    patchShebangs subprojects
  ''
  + lib.optionalString finalAttrs.doCheck ''
    substituteInPlace \
      "subprojects/meson-tests/common/14 configure file/test.py.in" \
      "subprojects/meson-tests/common/274 customtarget exe for test/generate.py" \
      "subprojects/meson-tests/native/8 external program shebang parsing/script.int.in" \
        --replace-fail "/usr/bin/env" "${coreutils}/bin/env"

    substituteInPlace \
      "subprojects/meson-tests/meson.build" \
        --replace-fail "['common/66 vcstag', {'python': true}]," ""
  '';

  enableParallelBuilding = true;

  buildPhase =
    let
      muonBool = lib.mesonBool;
      muonEnable = lib.mesonEnable;
      muonOption = lib.mesonOption;

      bootstrapFlags = lib.optionalString (!embedSamurai) "CFLAGS=\"$CFLAGS -DBOOTSTRAP_NO_SAMU\"";
      # see `muon options -a` to see built-in options
      cmdlineForMuon = lib.concatStringsSep " " [
        (muonOption "prefix" (placeholder "out"))
        # don't let muon override stdenv C flags
        (muonEnable "auto_features" true)
        (muonOption "buildtype" "plain")
        (muonOption "optimization" "plain")
        (muonOption "wrap_mode" "nodownload")
        # muon features
        (muonBool "static" stdenv.targetPlatform.isStatic)
        (muonEnable "man-pages" buildDocs)
        (muonEnable "meson-docs" buildDocs)
        (muonEnable "meson-tests" finalAttrs.doCheck)
        (muonEnable "samurai" embedSamurai)
        (muonEnable "tracy" false)
        (muonEnable "website" false)
      ];
      cmdlineForSamu = "-j$NIX_BUILD_CORES";
    in
    ''
      runHook preBuild

      ${bootstrapFlags} ./bootstrap.sh stage-1
      ./stage-1/muon-bootstrap setup ${cmdlineForMuon} stage-2
      ${lib.optionalString embedSamurai "./stage-1/muon-bootstrap"} samu ${cmdlineForSamu} -C stage-2

      runHook postBuild
    '';

  # tests only pass when samurai is embedded
  doCheck = embedSamurai && runTests;

  nativeCheckInputs = [
    # "common/220 fs module"
    writableTmpDirAsHomeHook
    # "common/44 pkgconfig-gen"
    pkg-config
    # "frameworks/6 gettext"
    gettext
  ]
  ++ lib.optionals stdenv.hostPlatform.isx86_64 [
    # "nasm/*" tests
    nasm
  ];

  checkPhase = ''
    runHook preCheck

    ./stage-2/muon -C stage-2 test -d dots -S -j$NIX_BUILD_CORES

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    stage-2/muon -C stage-2 install

    runHook postInstall
  '';

  passthru.srcsAttrs = {
    muon-src = fetchFromSourcehut {
      name = "muon-src";
      owner = "~lattis";
      repo = "muon";
      tag = finalAttrs.version;
      hash = "sha256-bWEYWUD+GK8R3yVnDTnzFWmm4KAuVPI+1yMfCXWcG/A=";
    };
    meson-docs = fetchFromGitHub {
      name = "meson-docs";
      repo = "meson-docs";
      owner = "muon-build";
      rev = "1017b3413601044fb41ad04977445e68a80e8181";
      hash = "sha256-aFpyJFIqybLNKhm/kyfCjYylj7DE6muI1+OUh4Cq4WY=";
      passthru.use = buildDocs;
    };
    meson-tests = fetchFromGitHub {
      name = "meson-tests";
      repo = "meson-tests";
      owner = "muon-build";
      rev = "db92588773a24f67cda2f331b945825ca3a63fa7";
      hash = "sha256-z4Fc1lr/m2MwIwhXJwoFWpzeNg+udzMxuw5Q/zVvpSM=";
      passthru.use = finalAttrs.doCheck;
    };
  };

  # tests are run here in package tests, rather than enabling doCheck by
  # default, to reduce the number of required dependencies.
  passthru.tests.test = (muon.overrideAttrs { pname = "muon-tests"; }).override {
    buildDocs = false;
    embedSamurai = true;
    runTests = true;
  };

  passthru.updateScript = callPackage ./update.nix { };

  meta = {
    homepage = "https://muon.build";
    description = "Implementation of the meson build system in C99";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    mainProgram = "muon";
  };
})
# TODO LIST:
# 1. setup hook
