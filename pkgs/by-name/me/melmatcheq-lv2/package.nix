{
  lib,
  stdenv,
  fetchFromGitHub,
  xorg,
  xorgproto,
  cairo,
  lv2,
  pkg-config,
}:

stdenv.mkDerivation {
  pname = "MelMatchEQ.lv2";
  version = "0.1-unstable-2025-01-30";

  src = fetchFromGitHub {
    owner = "brummer10";
    repo = "MelMatchEQ.lv2";
    rev = "bee24593209d5c53fdafa62cb43aeeab6c5e880f";
    hash = "sha256-eceY79s1X0gv0SsC4jJsFh7tq3VxQhcY9/bfJqYUxmk=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    xorg.libX11
    xorgproto
    cairo
    lv2
  ];

  installFlags = [ "INSTALL_DIR=$(out)/lib/lv2" ];

  meta = {
    homepage = "https://github.com/brummer10/MelMatchEQ.lv2";
    description = "Profiling EQ using a 26 step Mel Frequency Band";
    maintainers = with lib.maintainers; [ magnetophon ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
