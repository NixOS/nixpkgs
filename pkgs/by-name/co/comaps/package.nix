{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  fetchFromGitea,
  cmake,
  git,
  boost,
  qt6,
  python3,
  libXrandr,
  libXinerama,
  libXcursor,
}:
let
  mapRev = 250622;

  worldMap = fetchurl {
    url = "https://cdn.comaps.app/maps/${toString mapRev}/World.mwm";
    hash = "sha256-Jo8/dZU9gGHYGGe6KpMnJ3VcptjPlQMwMx99i3Q2wqo=";
  };

  worldCoasts = fetchurl {
    url = "https://cdn.comaps.app/maps/${toString mapRev}/WorldCoasts.mwm";
    hash = "sha256-P5ACBKVavp3PZezG1tbXcwhUTlBJja/u31fcaN7JK0o=";
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
  version = "2025.06.30-22";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "comaps";
    repo = "comaps";
    tag = "${finalAttrs.version}-android";
    hash = "sha256-kDDnRq8AAtfquEXUcZsulsM5+ufTVJCOis9E1QQIyJs=";
    fetchSubmodules = true;
  };

  patches = [
    # The world feed integration data is fetched externally, instead we fetch it ourselves.
    ./local-world-feed-integration-tests-data.patch
  ];

  nativeBuildInputs = [
    cmake
    git
    qt6.wrapQtAppsHook
    python3
  ];

  buildInputs = [
    boost
    qt6.qtbase
    qt6.qtpositioning
    qt6.qtsvg
    libXrandr
    libXinerama
    libXcursor
  ];

  preConfigure = ''
    cp -r ${worldFeedIntegrationTestsData} data/test_data/world_feed_integration_tests_data
  '';

  postInstall = ''
    install -Dm644 ${worldMap} $out/share/comaps/data/World.mwm
    install -Dm644 ${worldCoasts} $out/share/comaps/data/WorldCoasts.mwm
    mv $out/bin/CoMaps $out/bin/comaps
  '';

  meta = {
    description = "A community-led fork of Organic Maps";
    homepage = "https://comaps.app";
    changelog = "https://codeberg.org/comaps/comaps/releases/tag/${finalAttrs.version}-android";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.ryand56 ];
    mainProgram = "comaps";
  };
})
