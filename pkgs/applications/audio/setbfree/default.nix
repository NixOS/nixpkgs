{ lib, stdenv, fetchFromGitHub, alsa-lib, freetype, ftgl, libjack2, libX11, lv2
, libGLU, libGL, pkg-config, ttf_bitstream_vera
}:

stdenv.mkDerivation  rec {
  pname = "setbfree";
  version = "0.8.12";

  src = fetchFromGitHub {
    owner = "pantherb";
    repo = "setBfree";
    rev = "v${version}";
    sha256 = "sha256-e/cvD/CtT8dY1lYcsZ21DC8pNqKXqKfC/eRXX8k01eI=";
  };

  postPatch = ''
    substituteInPlace common.mak \
      --replace /usr/local "$out" \
      --replace /usr/share/fonts/truetype/ttf-bitstream-vera "${ttf_bitstream_vera}/share/fonts/truetype"
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    alsa-lib freetype ftgl libjack2 libX11 lv2 libGLU libGL
    ttf_bitstream_vera
  ];

  doInstallCheck = true;

  installCheckPhase = ''(
    set -x
    test -e $out/bin/setBfreeUI
  )'';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A DSP tonewheel organ emulator";
    homepage = "https://setbfree.org";
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" "i686-linux" ]; # fails on ARM and Darwin
    maintainers = [ maintainers.goibhniu ];
  };
}
