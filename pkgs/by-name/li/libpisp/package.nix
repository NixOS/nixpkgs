{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  meson,
  ninja,
  boost,
  nlohmann_json,
  fetchpatch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libpisp";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "libpisp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YshU7G5Rov67CVwFbf5ENp2j5ptAvkVrlMu85KmnEpk=";
  };

  patches = [
    # fix build with glibc 2.42 & -Werror
    (fetchpatch {
      url = "https://github.com/raspberrypi/libpisp/commit/f2bbf7e000d3f11cac235b8ea1291722080a016c.patch";
      hash = "sha256-vrdmVadyjlAnZtmBahOs/hlKPrkh/BF3LvrTPM9D15Q=";
    })
  ];

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
