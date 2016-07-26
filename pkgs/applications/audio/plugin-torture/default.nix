{ stdenv, fetchFromGitHub, boost, ladspaH, lilv, lv2, pkgconfig, serd, sord, sratom }:

stdenv.mkDerivation rec {
  name = "plugin-torture-${version}";
  version = "5";

  src = fetchFromGitHub {
    owner = "cth103";
    repo = "plugin-torture";
    rev = "v${version}";
    sha256 = "1mlgxjsyaz86wm4k32ll2w5nghjffnsdqlm6kjv02a4dpb2bfrih";
  };

  buildInputs = [ boost ladspaH lilv lv2 pkgconfig serd sord sratom ];

  installPhase = ''
    mkdir -p $out/bin
    cp plugin-torture $out/bin/
    cp find-safe-plugins $out/bin/
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/cth103/plugin-torture;
    description = "A tool to test LADSPA and LV2 plugins";
    license = licenses.gpl2;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
  };
}
