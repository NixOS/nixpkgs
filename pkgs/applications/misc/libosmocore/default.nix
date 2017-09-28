{ stdenv, fetchFromGitHub, autoreconfHook, pcsclite, pkgconfig
}:

stdenv.mkDerivation rec {
  name = "libosmocore-${version}";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "osmocom";
    repo = "libosmocore";
    rev = "8649d57f507d359c99a89654aac7e19ce22db282";
    sha256 = "08mcpy9ljwb1i3l4cmlwn024q2psk5gg9f0ylgh99hy1ffx0n7am";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [
    pcsclite
  ];

  preConfigure = ''
    autoreconf -i -f
  '';

  meta = with stdenv.lib; {
    description = "libosmocore";
    homepage = https://github.com/osmocom/libosmocore;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mog ];
  };
}
