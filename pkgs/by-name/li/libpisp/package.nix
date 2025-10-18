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
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "libpisp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cgyV60+cGHGr8LTDoSTeqvwdspPSyR5goPMgKR1xo9Y=";
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

  meta = with lib; {
    homepage = "https://github.com/raspberrypi/libpisp";
    description = "Helper library to generate run-time configuration for the Raspberry Pi ISP (PiSP), consisting of the Frontend and Backend hardware components";
    license = licenses.bsd2;
    platforms = platforms.all;
  };
})
