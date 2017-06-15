{ stdenv, fetchFromGitHub, glib, lilv, lv2, pkgconfig, serd, sord, sratom }:

stdenv.mkDerivation rec {
  name = "lv2bm-${version}";
  version = "git-2015-11-29";

  src = fetchFromGitHub {
    owner = "moddevices";
    repo = "lv2bm";
    rev = "e844931503b7597f45da6d61ff506bb9fca2e9ca";
    sha256 = "1rrz5sp04zjal6v34ldkl6fjj9xqidb8xm1iscjyljf6z4l516cx";
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
