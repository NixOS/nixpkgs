{
  lib,
  pkgsBuildBuild,
  stdenv,
  fetchFromSourcehut,
  fetchurl,
  curl,
  libarchive,
  libpkgconf,
  ninja, # FIXME: remove ninja once builds work without it
  pkgconf,
  python3,
  samurai,
  scdoc,
  zlib,
  embedSamurai ? false,
  buildDocs ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "muon" + lib.optionalString embedSamurai "-embedded-samurai";
  version = "0.4.0";

  src = fetchFromSourcehut {
    name = "muon-src";
    owner = "~lattis";
    repo = "muon";
    rev = finalAttrs.version;
    hash = "sha256-xTdyqK8t741raMhjjJBMbWnAorLMMdZ02TeMXK7O+Yw=";
  };

  outputs = [ "out" ] ++ lib.optionals buildDocs [ "man" ];

  nativeBuildInputs =
    [
      pkgconf
    ]
    ++ lib.optionals (!embedSamurai) [
      ninja
      samurai
    ]
    ++ lib.optionals buildDocs [
      (python3.withPackages (ps: [ ps.pyyaml ]))
      scdoc
    ];

  buildInputs = [
    curl
    libarchive
    libpkgconf
    zlib
  ];

  strictDeps = true;

  postUnpack =
    let
      # URLs manually extracted from subprojects directory
      meson-docs-wrap = fetchurl {
        name = "meson-docs-wrap";
        url = "https://github.com/muon-build/meson-docs/archive/5bc0b250984722389419dccb529124aed7615583.tar.gz";
        hash = "sha256-5MmmiZfadCuUJ2jy5Rxubwf4twX0jcpr+TPj5ssdSbM=";
      };
    in
    ''
      pushd $sourceRoot/subprojects
      ${lib.optionalString buildDocs "tar xvf ${meson-docs-wrap}"}
      popd
    '';

  postPatch =
    ''
      patchShebangs bootstrap.sh
    ''
    + lib.optionalString buildDocs ''
      patchShebangs subprojects/meson-docs/docs/genrefman.py
    '';

  # tests try to access "~"
  postConfigure = ''
    export HOME=$(mktemp -d)
  '';

  buildPhase =
    let
      muonBool = lib.mesonBool;
      muonEnable = lib.mesonEnable;

      cmdlineForMuon = lib.concatStringsSep " " [
        (muonBool "static" stdenv.targetPlatform.isStatic)
        (muonEnable "docs" buildDocs)
        (muonEnable "samurai" embedSamurai)
      ];
      cmdlineForSamu = "-j$NIX_BUILD_CORES";
    in
    ''
      runHook preBuild

      CC=${lib.getExe pkgsBuildBuild.stdenv.cc} ./bootstrap.sh stage-1

      CC=${lib.getExe pkgsBuildBuild.stdenv.cc} ./stage-1/muon-bootstrap setup ${cmdlineForMuon} stage-2
      CC=${lib.getExe pkgsBuildBuild.stdenv.cc} ./stage-1/muon-bootstrap samu ${cmdlineForSamu} -C stage-2

      ./stage-2/muon setup -Dprefix=$out ${cmdlineForMuon} stage-3
      ${lib.optionalString embedSamurai "./stage-2/muon"} samu ${cmdlineForSamu} -C stage-3

      runHook postBuild
    '';

  # tests are failing because they don't find Python
  doCheck = false;

  checkPhase = ''
    runHook preCheck

    ./stage-3/muon -C stage-3 test

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
    broken = stdenv.hostPlatform.isDarwin; # typical `ar failure`
    mainProgram = "muon";
  };
})
# TODO LIST:
# 1. automate sources acquisition (especially wraps)
# 2. setup hook
# 3. tests
