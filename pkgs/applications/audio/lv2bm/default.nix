{ stdenv, fetchFromGitHub, glib, lilv, lv2, pkgconfig, serd, sord, sratom }:

stdenv.mkDerivation rec {
  name = "lv2bm-${version}";
  version = "git-2015-04-10";

  src = fetchFromGitHub {
    owner = "portalmod";
    repo = "lv2bm";
    rev = "08681624fc13eb700ec2b5cabedbffdf095e28b3";
    sha256 = "11pi97jy4f4c3vsaizc8a6sw9hnhnanj6y1fil33yd9x7f8f0kbj";
  };

  buildInputs = [ glib lilv lv2 pkgconfig serd sord sratom ];

  installPhase = ''
    make install PREFIX=$out
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/portalmod/lv2bm;
    description = "A benchmark tool for LV2 plugins";
    license = licenses.gpl3;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
  };
}
