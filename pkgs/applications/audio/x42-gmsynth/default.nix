{ lib, stdenv, fetchFromGitHub, pkg-config, glib, lv2 }:

stdenv.mkDerivation rec {
  pname = "x42-gmsynth";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "x42";
    repo = "gmsynth.lv2";
    rev = "v${version}";
    hash = "sha256-onZoaQVAGH/1d7jBRlN3ucx/3mTGUCxjvvt19GyprsY=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ glib lv2 ];

  makeFlags = [
    "PREFIX=$(out)"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    description = "Chris Colins' General User soundfont player LV2 plugin";
    homepage = "https://x42-plugins.com/x42/x42-gmsynth";
    maintainers = with maintainers; [ orivej ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
