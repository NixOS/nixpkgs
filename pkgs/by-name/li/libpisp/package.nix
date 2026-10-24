{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  meson,
  ninja,
  boost,
  nlohmann_json,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libpisp";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "libpisp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hzJA8hoOXf2Lswwz9t0StJ9JJP8ICWJlstzSsli4Yqs=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];
  buildInputs = [
    boost
    nlohmann_json
  ];

  meta = {
    homepage = "https://github.com/raspberrypi/libpisp";
    description = "Helper library to generate run-time configuration for the Raspberry Pi ISP (PiSP), consisting of the Frontend and Backend hardware components";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.all;
  };
})
