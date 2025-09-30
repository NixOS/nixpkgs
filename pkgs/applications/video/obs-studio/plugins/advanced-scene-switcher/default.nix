{
  lib,
  fetchFromGitHub,
  nix-update-script,

  cmake,
  ninja,

  alsa-lib,
  asio,
  curl,
  libremidi,
  nlohmann_json,
  obs-studio,
  opencv,
  procps,
  qtbase,
  stdenv,
  websocketpp,
  libXScrnSaver,
  libusb1,
  pkg-config,
# #FIXME: Could not get cmake to pick up on these dependencies
# Ommiting them prevents cmake from building the OCR video capabilities
# Everything else should work it's just missing this one plugin
# tesseract,
# leptonica,
}:
let
  httplib-src = fetchFromGitHub {
    owner = "yhirose";
    repo = "cpp-httplib";
    rev = "v0.13.3";
    hash = "sha256-ESaH0+n7ycpOKM+Mnv/UgT16UEx86eFMQDHB3RVmgBw=";
  };
in
stdenv.mkDerivation rec {
  pname = "advanced-scene-switcher";
  version = "1.31.0";

  src = fetchFromGitHub {
    owner = "WarmUpTill";
    repo = "SceneSwitcher";
    rev = version;
    hash = "sha256-9gCGzIvVMQewphThdNJKUVgJYzrfkn18A97RL+4IHM8=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    asio
    curl
    libremidi
    nlohmann_json
    obs-studio
    opencv
    # tesseract
    # leptonica
    procps
    qtbase
    websocketpp
    libXScrnSaver
    libusb1
  ];

  dontWrapQtApps = true;

  postUnpack = ''
    cp -r ${httplib-src}/* $sourceRoot/deps/cpp-httplib
    cp -r ${libremidi.src}/* $sourceRoot/deps/libremidi
    chmod -R +w $sourceRoot/deps/cpp-httplib
    chmod -R +w $sourceRoot/deps/libremidi
  '';

  # PipeWire support currently disabled in libremidi dependency.
  # see https://github.com/NixOS/nixpkgs/pull/374469
  cmakeFlags = [ (lib.cmakeBool "LIBREMIDI_NO_PIPEWIRE" true) ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=stringop-overflow -Wno-error=deprecated-declarations";

  passthru.updateScript = nix-update-script { };
  meta = with lib; {
    description = "Automated scene switcher for OBS Studio";
    homepage = "https://github.com/WarmUpTill/SceneSwitcher";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with lib.maintainers; [ patrickdag ];
  };
}
