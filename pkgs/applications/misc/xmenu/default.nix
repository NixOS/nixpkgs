{ lib, stdenv, fetchFromGitHub, imlib2, libX11, libXft, libXinerama }:

stdenv.mkDerivation rec {
  pname = "xmenu";
  version = "4.5.4";

  src = fetchFromGitHub {
    owner = "phillbush";
    repo = "xmenu";
    rev = "v${version}";
    sha256 = "1dy3aqqczs7d3f8rf6h7xssgr3881g8m5y4waskizjy9z7chs64q";
  };

  buildInputs = [ imlib2 libX11 libXft libXinerama ];

  postPatch = "sed -i \"s:/usr/local:$out:\" config.mk";

  meta = with lib; {
    description = "A menu utility for X";
    homepage = "https://github.com/phillbush/xmenu";
    license = licenses.mit;
    maintainers = with maintainers; [ neonfuz ];
    platforms = platforms.all;
  };
}
