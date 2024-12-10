{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  cmake,
  libspecbleach,
  lv2,
}:

stdenv.mkDerivation rec {
  pname = "noise-repellent";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "lucianodato";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-d8csYC3z3vXdmN/G6mAK+H8ia0vOCsoUpoA3W8/OADc=";
  };

  mesonFlags = [
    "--prefix=${placeholder "out"}/lib/lv2"
    "--buildtype=release"
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    cmake
  ];
  buildInputs = [
    libspecbleach
    lv2
  ];

  meta = with lib; {
    description = "An lv2 plugin for broadband noise reduction";
    homepage = "https://github.com/lucianodato/noise-repellent";
    license = licenses.gpl3;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.unix;
  };
}
