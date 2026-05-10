{
  stdenv,
  lib,
  fetchFromGitLab,
  cmake,
  pkg-config,
  cairo,
  libxkbcommon,
  libxcb-cursor,
  libxcb-keysyms,
  libxcb-util,
  libxrandr,
  libxinerama,
  libxcursor,
  alsa-lib,
  libjack2,
  lv2,
  gcc-unwrapped,
  curl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "librearp-lv2";
  version = "2.4";

  src = fetchFromGitLab {
    owner = "LibreArp";
    repo = "LibreArp";
    rev = "${finalAttrs.version}-lv2";
    hash = "sha256-x+ZPiU/ZFzrXb8szMS9Ts4JEEyXYpM8CLZHT4lNJWY8=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    cairo
    libxkbcommon
    libxcb-cursor
    libxcb-keysyms
    libxcb-util
    libxrandr
    libxinerama
    libxcursor
    alsa-lib
    libjack2
    lv2
    curl
  ];

  cmakeFlags = [
    "-DCMAKE_AR=${gcc-unwrapped}/bin/gcc-ar"
    "-DCMAKE_RANLIB=${gcc-unwrapped}/bin/gcc-ranlib"
    "-DCMAKE_NM=${gcc-unwrapped}/bin/gcc-nm"
  ];

  installPhase = ''
    mkdir -p $out/lib/lv2
    cd LibreArp_artefacts/Release
    cp -r LV2/LibreArp.lv2 $out/lib/lv2
  '';

  meta = {
    description = "Pattern-based arpeggio generator plugin";
    homepage = "https://librearp.gitlab.io/";
    license = lib.licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ magnetophon ];
  };
})
