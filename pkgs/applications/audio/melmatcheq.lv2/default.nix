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

stdenv.mkDerivation rec {
  pname = "MelMatchEQ.lv2";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "brummer10";
    repo = pname;
    rev = "v${version}";
    sha256 = "1s805jgb9msxfq9047s7pxrngizb00w8sm4z94iii80ba65rd20x";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    xorg.libX11
    xorgproto
    cairo
    lv2
  ];

  installFlags = [ "INSTALL_DIR=$(out)/lib/lv2" ];

  meta = with lib; {
    homepage = "https://github.com/brummer10/MelMatchEQ.lv2";
    description = "a profiling EQ using a 26 step Mel Frequency Band";
    maintainers = with maintainers; [ magnetophon ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
