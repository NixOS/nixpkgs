{ stdenv, fetchgit, boost, ladspaH, lilv, lv2, pkgconfig, serd, sord, sratom }:

stdenv.mkDerivation rec {
  name = "plugin-torture-git-${version}";
  version = "2013-10-03";

  src = fetchgit {
    url = "https://github.com/cth103/plugin-torture";
    rev = "9ee06016982bdfbaa215cd0468cc6ada6367462a";
    sha256 = "0ynzfs3z95lbw4l1w276as2a37zxp0cw6pi3lbikr0qk0r7j5j10";
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
