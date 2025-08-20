{
  lib,
  stdenv,
  fetchFromSourcehut,
  fetchFromGitHub,
  coreutils,
  curl,
  libarchive,
  libpkgconf,
  pkgconf,
  python3,
  samurai,
  scdoc,
  writableTmpDirAsHomeHook,
  zlib,
  embedSamurai ? false,
  buildDocs ? true,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "muon" + lib.optionalString embedSamurai "-embedded-samurai";
  version = "0.5.0";

  srcs = [
    (fetchFromSourcehut {
      name = "muon-src";
      owner = "~lattis";
      repo = "muon";
      tag = finalAttrs.version;
      hash = "sha256-bWEYWUD+GK8R3yVnDTnzFWmm4KAuVPI+1yMfCXWcG/A=";
    })
    (fetchFromGitHub {
      name = "meson-tests";
      repo = "meson-tests";
      owner = "muon-build";
      rev = "db92588773a24f67cda2f331b945825ca3a63fa7";
      hash = "sha256-z4Fc1lr/m2MwIwhXJwoFWpzeNg+udzMxuw5Q/zVvpSM=";
    })
  ]
  ++ lib.optionals buildDocs [
    (fetchFromGitHub {
      name = "meson-docs";
      repo = "meson-docs";
      owner = "muon-build";
      rev = "1017b3413601044fb41ad04977445e68a80e8181";
      hash = "sha256-aFpyJFIqybLNKhm/kyfCjYylj7DE6muI1+OUh4Cq4WY=";
    })
  ];

  sourceRoot = "./muon-src";

  outputs = [ "out" ] ++ lib.optionals buildDocs [ "man" ];

  nativeBuildInputs = [
    pkgconf
    (python3.withPackages (ps: [ ps.pyyaml ]))
  ]
  ++ lib.optionals (!embedSamurai) [ samurai ]
  ++ lib.optionals buildDocs [ scdoc ];

  buildInputs = [
    curl
    libarchive
    libpkgconf
    zlib
  ];

  strictDeps = true;

  postUnpack = ''
    for subproject in ${lib.optionalString buildDocs "meson-docs"} meson-tests; do
      cp -r "$subproject" "$sourceRoot/subprojects/$subproject"
      chmod +w -R "$sourceRoot/subprojects/$subproject"
      rm "$sourceRoot/subprojects/$subproject.wrap"
    done
  '';

  patches = [ ./darwin-clang.patch ];

  postPatch = ''
    find subprojects/meson-tests -name "*.py" -exec chmod +x {} \;
    patchShebangs .

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

      cmdlineForMuon = lib.concatStringsSep " " [
        (muonOption "prefix" (placeholder "out"))
        (muonBool "static" stdenv.targetPlatform.isStatic)
        (muonEnable "meson-docs" buildDocs)
        (muonEnable "samurai" embedSamurai)
        (muonEnable "tracy" false)
      ];
      cmdlineForSamu = "-j$NIX_BUILD_CORES";
    in
    ''
      runHook preBuild

      ${
        lib.optionalString (!embedSamurai) "CFLAGS=\"$CFLAGS -DBOOTSTRAP_NO_SAMU\""
      } ./bootstrap.sh stage-1

      ./stage-1/muon-bootstrap setup ${cmdlineForMuon} stage-2
      ${lib.optionalString embedSamurai "./stage-1/muon-bootstrap"} samu ${cmdlineForSamu} -C stage-2

      ./stage-2/muon setup ${cmdlineForMuon} stage-3
      ${lib.optionalString embedSamurai "./stage-2/muon"} samu ${cmdlineForSamu} -C stage-3

      runHook postBuild
    '';

  # tests only pass when samurai is embedded
  doCheck = embedSamurai;

  nativeCheckInputs = [
    # needed for "common/220 fs module"
    writableTmpDirAsHomeHook
  ];

  checkPhase = ''
    runHook preCheck

    ${lib.optionalString (
      stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64
    ) "NIX_BUILD_CORES=1"}
    ./stage-3/muon -C stage-3 test -d dots -S -j$NIX_BUILD_CORES

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    stage-3/muon -C stage-3 install

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://muon.build/";
    description = "Implementation of Meson build system in C99";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
    mainProgram = "muon";
  };
})
# TODO LIST:
# 1. automate sources acquisition (especially wraps)
# 2. setup hook
