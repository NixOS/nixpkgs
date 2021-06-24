{ stdenv, lib, fetchFromGitHub, pkg-config, gtk2 }:

stdenv.mkDerivation rec {
  pname = "spnavcfg";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "FreeSpacenav";
    repo = pname;
    rev = "v${version}";
    sha256 = "180mkdis15gxs79rr3f7hpwa1p6v81bybw37pzzdjnmqwqrc08a0";
  };

  postPatch = ''
    sed -i s/4775/775/ Makefile.in
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gtk2 ];

  meta = with lib; {
    homepage = "http://spacenav.sourceforge.net/";
    description = "Interactive configuration GUI for space navigator input devices";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ gebner ];
  };
}
