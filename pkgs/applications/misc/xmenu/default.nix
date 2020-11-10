{ stdenv, fetchFromGitHub, imlib2, libX11, libXft, libXinerama }:

stdenv.mkDerivation rec {
  pname = "xmenu";
  version = "4.3.1";

  src = fetchFromGitHub {
    owner = "phillbush";
    repo = "xmenu";
    rev = "v${version}";
    sha256 = "0m97w1nwak5drcxxlyisqb73fxkapy2rlph9mg531kbx3k2h30r1";
  };

  buildInputs = [ imlib2 libX11 libXft libXinerama ];

  postPatch = "sed -i \"s:/usr/local:$out:\" config.mk";

  meta = with stdenv.lib; {
    description = "A menu utility for X";
    homepage = "https://github.com/phillbush/xmenu";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ neonfuz ];
    platforms = platforms.all;
  };
}
