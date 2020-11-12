{ stdenv, fetchFromGitHub, imlib2, libX11, libXft, libXinerama }:

stdenv.mkDerivation rec {
  pname = "xmenu";
  version = "4.4.1";

  src = fetchFromGitHub {
    owner = "phillbush";
    repo = "xmenu";
    rev = "v${version}";
    sha256 = "1s70zvsaqnsjqs298vw3py0vcvia68xlks1wcz37pb88bwligz1x";
  };

  buildInputs = [ imlib2 libX11 libXft libXinerama ];

  postPatch = "sed -i \"s:/usr/local:$out:\" config.mk";

  meta = with stdenv.lib; {
    description = "A menu utility for X";
    homepage = "https://github.com/phillbush/xmenu";
    license = licenses.mit;
    maintainers = with maintainers; [ neonfuz ];
    platforms = platforms.all;
  };
}
