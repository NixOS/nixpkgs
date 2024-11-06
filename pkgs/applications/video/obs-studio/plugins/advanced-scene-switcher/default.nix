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
  fetchpatch,
# #FIXME: Could not get cmake to pick up on these dependencies
# Prevents cmake from building the OCR video capabilities
# Everything else should work just missing this on plugin
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
  version = "1.28.1";

  src = fetchFromGitHub {
    owner = "WarmUpTill";
    repo = "SceneSwitcher";
    rev = version;
    hash = "sha256-1U5quhfdhEBcCbEzW0uEpimYgvdbsIwaL2EdQ4cLF/M=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  patches = [
    # https://github.com/WarmUpTill/SceneSwitcher/pull/1244
    (fetchpatch {
      url = "https://github.com/WarmUpTill/SceneSwitcher/commit/e0c650574f9f7f6cae5626afa9abf8a838dc0858.diff";
      hash = "sha256-eXO8LdGYf60sd/kyxWVDSEpwyzp4Uu9TpPADg5ED4yU=";
    })
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
