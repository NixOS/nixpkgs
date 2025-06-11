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

  version = "unstable-2018-02-11";

  src = fetchFromGitHub {
    owner = "periklis";
    repo = "lguf-brightness";
    rev = "fcb2bc1738d55c83b6395c24edc27267a520a725";
    sha256 = "0cf7cn2kpmlvz00qxqj1m5zxmh7i2x75djbj4wqk7if7a0nlrd5m";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    libusb1
    ncurses5
  ];

  installPhase = ''
    install -D lguf_brightness $out/bin/lguf_brightness
  '';

  meta = with lib; {
    description = "Adjust brightness for LG UltraFine 4K display (cross platform)";
    homepage = "https://github.com/periklis/lguf-brightness";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ periklis ];
    mainProgram = "lguf_brightness";
    platforms = with platforms; linux ++ darwin;
  };
}
