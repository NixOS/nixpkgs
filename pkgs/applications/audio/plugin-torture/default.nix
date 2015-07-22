{ stdenv, fetchgit, boost, ladspaH, lilv, lv2, pkgconfig, serd, sord, sratom }:

stdenv.mkDerivation rec {
  name = "plugin-torture-git-${version}";
  version = "2013-10-03";

  src = fetchgit {
    url = "https://github.com/cth103/plugin-torture";
    rev = "9ee06016982bdfbaa215cd0468cc6ada6367462a";
    sha256 = "bfe9213fd2c1451d7acc1381d63301c4e6ff69ce86d31a886ece5159ba850706";
  };

  buildInputs = [ boost ladspaH lilv lv2 pkgconfig serd sord sratom ];

  installPhase = ''
    mkdir -p $out/bin
    cp plugin-torture $out/bin/
    cp README $out/bin/
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/cth103/plugin-torture;
    description = "A tool to test LADSPA and LV2 plugins";
    license = licenses.gpl2;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
  };
}
