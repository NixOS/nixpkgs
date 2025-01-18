{
  lib,
  stdenv,
  fetchFromGitHub,
  boost,
  gtkmm2,
  lv2,
  pkg-config,
  python3,
  meson,
  pugl,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lvtk";
  version = "1.2.0-unstable-2024-11-06";

  src = fetchFromGitHub {
    owner = "lvtk";
    repo = "lvtk";
    rev = "0797fdcabef84f57b064c7b4507743afebc66589";
    hash = "sha256-Z79zy2/OZTO6RTrAqgTHTzB00LtFTFiJ272RvQRpbH8=";
  };

  nativeBuildInputs = [
    pkg-config
    python3
    meson
    ninja
  ];

  buildInputs = [
    boost
    gtkmm2
    lv2
    pugl
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Set C++ wrappers around the LV2 C API";
    mainProgram = "ttl2c";
    homepage = "https://lvtk.org/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ bot-wxt1221 ];
    platforms = platforms.unix;
    badPlatforms = [
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
})
