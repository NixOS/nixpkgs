{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libusb1,
  ncurses5,
}:

stdenv.mkDerivation {
  pname = "lguf-brightness";

  version = "0-unstable-2019-02-07";

  src = fetchFromGitHub {
    owner = "periklis";
    repo = "lguf-brightness";
    rev = "fcb2bc1738d55c83b6395c24edc27267a520a725";
    hash = "sha256-tbRMLVDHxTMxJ3LJVk4X8cDaf6lB4o4B+JvWO4VlxzE=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    libusb1
    ncurses5
  ];

  installPhase = ''
    install -D lguf_brightness $out/bin/lguf_brightness
  '';

  meta = {
    description = "Adjust brightness for LG UltraFine 4K display (cross platform)";
    homepage = "https://github.com/periklis/lguf-brightness";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ ];
    mainProgram = "lguf_brightness";
    platforms = with lib.platforms; linux ++ darwin;
  };
}
