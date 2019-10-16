{ stdenv, fetchzip, alsaLib, freetype, ftgl, libjack2, libX11, lv2
, libGLU_combined, pkgconfig, ttf_bitstream_vera
}:

stdenv.mkDerivation  rec {
  pname = "setbfree";
  version = "0.8.9";

  src = fetchzip {
    url = "https://github.com/pantherb/setBfree/archive/v${version}.tar.gz";
    sha256 = "097bby2da47zlkaqy2jl8j6q0h5pxaq67lz473ygadqs5ic3nhc1";
  };

  postPatch = ''
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
    homepage = "http://setbfree.org";
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" "i686-linux" ]; # fails on ARM and Darwin
    maintainers = [ maintainers.goibhniu ];
  };
}
