{ lib, stdenv, fetchFromGitHub, alsa-lib, freetype, ftgl, libjack2, libX11, lv2
, libGLU, libGL, pkg-config, ttf_bitstream_vera
}:

stdenv.mkDerivation  rec {
  pname = "setbfree";
  version = "0.8.11";

  src = fetchFromGitHub {
    owner = "pantherb";
    repo = "setBfree";
    rev = "v${version}";
    sha256 = "sha256-OYrsq3zVaotmS1KUgDIQbVQgxpfweMKiB17/PC1iXDA=";
  };

  postPatch = ''
    sed 's#/usr/local#$(out)#g' -i common.mak
    sed 's#/usr/share/fonts/truetype/ttf-bitstream-vera#${ttf_bitstream_vera}/share/fonts/truetype#g' \
      -i b_synth/Makefile
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    alsa-lib freetype ftgl libjack2 libX11 lv2 libGLU libGL
    ttf_bitstream_vera
  ];

  meta = with lib; {
    description = "A DSP tonewheel organ emulator";
    homepage = "https://setbfree.org";
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" "i686-linux" ]; # fails on ARM and Darwin
    maintainers = [ maintainers.goibhniu ];
  };
}
