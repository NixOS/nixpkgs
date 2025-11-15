{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  extra-cmake-modules,
  icecream,
  libcap_ng,
  libsForQt5,
  lzo,
  zstd,
  libarchive,
}:

stdenv.mkDerivation rec {
  pname = "icemon";
  version = "3.3";

  src = fetchFromGitHub {
    owner = "icecc";
    repo = "icemon";
    rev = "v${version}";
    sha256 = "09jnipr67dhawbxfn69yh7mmjrkylgiqmd0gmc2limd3z15d7pgc";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    libsForQt5.wrapQtAppsHook
  ];
  buildInputs = [
    icecream
    libsForQt5.qtbase
    libcap_ng
    lzo
    zstd
    libarchive
  ];

  meta = {
    description = "Icecream GUI Monitor";
    inherit (src.meta) homepage;
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ emantor ];
    platforms = with lib.platforms; linux ++ darwin;
    mainProgram = "icemon";
  };
}
