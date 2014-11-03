{ stdenv, fetchurl, alsaLib, freetype, ftgl, jack2, libX11, lv2
, mesa, pkgconfig, ttf_bitstream_vera
}:

stdenv.mkDerivation  rec {
  name = "setbfree-${version}";
  version = "0.7.5";

  src = fetchurl {
    url = "https://github.com/pantherb/setBfree/archive/v${version}.tar.gz";
    sha256 = "1chlmgwricc6l4kyg35vc9v8f1n8psr28iihn4a9q2prj1ihqcbc";
  };

  patchPhase = ''
    sed 's#/usr/local#$(out)#g' -i common.mak
    sed 's#/usr/share/fonts/truetype/ttf-bitstream-vera#${ttf_bitstream_vera}/share/fonts/truetype#g' \
      -i b_synth/Makefile
  '';

  buildInputs = [
    alsaLib freetype ftgl jack2 libX11 lv2 mesa pkgconfig
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
