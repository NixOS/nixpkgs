{ stdenv, fetchzip, alsaLib, freetype, ftgl, libjack2, libX11, lv2
, libGLU, libGL, pkgconfig, ttf_bitstream_vera
}:

stdenv.mkDerivation  rec {
  pname = "setbfree";
  version = "0.8.11";

  src = fetchzip {
    url = "https://github.com/pantherb/setBfree/archive/v${version}.tar.gz";
    sha256 = "0c2wc8nkrzsy0yic4y7hjz320m3d20r8152j9dk8nsnmgjmyr2ir";
  };

  postPatch = ''
    sed 's#/usr/local#$(out)#g' -i common.mak
    sed 's#/usr/share/fonts/truetype/ttf-bitstream-vera#${ttf_bitstream_vera}/share/fonts/truetype#g' \
      -i b_synth/Makefile
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    alsaLib freetype ftgl libjack2 libX11 lv2 libGLU libGL
    ttf_bitstream_vera
  ];

  meta = with stdenv.lib; {
    description = "A DSP tonewheel organ emulator";
    homepage = "http://setbfree.org";
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" "i686-linux" ]; # fails on ARM and Darwin
    maintainers = [ maintainers.goibhniu ];
  };
}
