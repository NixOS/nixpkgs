{
  lib,
  organicmaps,
  fetchurl,
  fetchFromGitea,
  boost,
  gtest,
  glm,
  gflags,
  imgui,
  jansson,
  python3,
  optipng,
  utf8cpp,
  nix-update-script,
}:
let
  mapRev = 250822;

  worldMap = fetchurl {
    url = "https://cdn-fi-1.comaps.app/maps/${toString mapRev}/World.mwm";
    hash = "sha256-OksUAix8yw0WQiJUwfMrjOCd/OwuRjdCOUjjGpnG2S8=";
  };

  worldCoasts = fetchurl {
    url = "https://cdn-fi-1.comaps.app/maps/${toString mapRev}/WorldCoasts.mwm";
    hash = "sha256-1OvKZJ3T/YJu6t/qTYliIVkwsT8toBSqGHUpDEk9i2k=";
  };
in
organicmaps.overrideAttrs (oldAttrs: rec {
  pname = "comaps";
  version = "2025.08.31-15";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "comaps";
    repo = "comaps";
    tag = "v${version}";
    hash = "sha256-uRShcyMevNb/UE5+l8UabiGSr9TccVWp5xVoqI7+Oh8=";
    fetchSubmodules = true;
  };

  patches = [
    ./remove-lto.patch
    ./use-vendored-protobuf.patch

    # Include missing editor_tests_support.
    ./fix-editor-tests.patch
  ];

  postPatch = (oldAttrs.postPatch or "") + ''
    rm -f 3party/boost/b2
  '';

  nativeBuildInputs = (builtins.filter (x: x != python3) oldAttrs.nativeBuildInputs or [ ]) ++ [
    (python3.withPackages (
      ps: with ps; [
        protobuf
      ]
    ))
    optipng
  ];

  buildInputs = (oldAttrs.buildInputs or [ ]) ++ [
    boost
    gtest
    gflags
    glm
    imgui
    jansson
    utf8cpp
  ];

  preConfigure = ''
    bash ./configure.sh --skip-map-download
  '';

  cmakeFlags = [
    (lib.cmakeBool "WITH_SYSTEM_PROVIDED_3PARTY" true)
  ];

  env = {
    NIX_CFLAGS_COMPILE = toString [
      "-I/build/source/3party/fast_double_parser/include"
    ];
    PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION = "python";
  };

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

  meta = oldAttrs.meta // {
    description = "Community-led fork of Organic Maps";
    homepage = "https://comaps.app";
    changelog = "https://codeberg.org/comaps/comaps/releases/tag/v${version}";
    maintainers = [ lib.maintainers.ryand56 ];
    mainProgram = "comaps";
  };
})
