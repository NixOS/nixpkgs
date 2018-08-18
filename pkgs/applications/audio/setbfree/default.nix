{ stdenv, fetchurl, alsaLib, freetype, ftgl, libjack2, libX11, lv2
, libGLU_combined, pkgconfig, ttf_bitstream_vera
}:

stdenv.mkDerivation  rec {
  name = "setbfree-${version}";
  version = "0.8.7";

  src = fetchurl {
    url = "https://github.com/pantherb/setBfree/archive/v${version}.tar.gz";
    sha256 = "07s320r67cz0cdjdsbcwn0fw3xs0wz7lgrybqpws2skvkbls228q";
  };

  patchPhase = ''
    sed 's#/usr/local#$(out)#g' -i common.mak
    sed 's#/usr/share/fonts/truetype/ttf-bitstream-vera#${ttf_bitstream_vera}/share/fonts/truetype#g' \
      -i b_synth/Makefile
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    alsaLib freetype ftgl libjack2 libX11 lv2 libGLU_combined
    ttf_bitstream_vera
  ];

  meta = with stdenv.lib; {
    description = "A DSP tonewheel organ emulator";
    homepage = http://setbfree.org;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
