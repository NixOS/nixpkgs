{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  fetchFromGitea,
  cmake,
  boost,
  gflags,
  jansson,
  qt6,
  python3,
  optipng,
  libXrandr,
  libXinerama,
  libXcursor,
  nix-update-script,
}:
let
  mapRev = 250713;

  worldMap = fetchurl {
    url = "https://cdn.comaps.app/maps/${toString mapRev}/World.mwm";
    hash = "sha256-nHXc8O8Am4P2quR0KdS3qClWc+33hDLg6sG3Fch2okA=";
  };

  worldCoasts = fetchurl {
    url = "https://cdn.comaps.app/maps/${toString mapRev}/WorldCoasts.mwm";
    hash = "sha256-HOnu8rETA0DVrq1hpQc72oPJWiGmGM00KTLIWYTqlIo=";
  };

  worldFeedIntegrationTestsData = fetchFromGitHub {
    owner = "organicmaps";
    repo = "world_feed_integration_tests_data";
    rev = "30ecb0b3fe694a582edfacc2a7425b6f01f9fec6";
    hash = "sha256-1FF658OhKg8a5kKX/7TVmsxZ9amimn4lB6bX9i7pnI4=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "comaps";
  version = "2025.08.13-8";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "comaps";
    repo = "comaps";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kvE3H+siV/8v4WgsG1Ifd4gMMwGLqz28oXf1hB9gQ2Q=";
    fetchSubmodules = true;
  };

  patches = [
    # The world feed integration data is fetched externally, instead we fetch it ourselves.
    ./local-world-feed-integration-tests-data.patch
  ];

  postPatch = ''
    ln -s ${worldFeedIntegrationTestsData} data/test_data/world_feed_integration_tests_data
  '';

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
    python3
    optipng
  ];

  buildInputs = with qt6; [
    boost
    gflags
    jansson
    qtbase
    qtpositioning
    qtsvg
    qtwayland
    libXrandr
    libXinerama
    libXcursor
  ];

  cmakeFlags = [
    (lib.cmakeBool "WITH_SYSTEM_PROVIDED_3PARTY" true)
  ];

  postInstall = ''
    install -Dm644 ${worldMap} $out/share/comaps/data/World.mwm
    install -Dm644 ${worldCoasts} $out/share/comaps/data/WorldCoasts.mwm
    ln -s $out/bin/CoMaps $out/bin/comaps
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "-vr"
      "v(.*)"
    ];
  };

  meta = {
    description = "A community-led fork of Organic Maps";
    homepage = "https://comaps.app";
    changelog = "https://codeberg.org/comaps/comaps/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.ryand56 ];
    platforms = lib.platforms.all;
    broken = stdenv.hostPlatform.isDarwin;
    mainProgram = "comaps";
  };
})
