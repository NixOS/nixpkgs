{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, lv2
, libGLU
, libGL
, gtk2
, cairo
, pango
, fftwFloat
, libjack2
}:

stdenv.mkDerivation rec {
  pname = "meters.lv2";
  version = "0.9.10";
  robtkVersion = "0.6.2";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ lv2 libGLU libGL gtk2 cairo pango fftwFloat libjack2 ];

  src = fetchFromGitHub {
    owner = "x42";
    repo = "meters.lv2";
    rev = "v${version}";
    sha256 = "sha256-u2KIsaia0rAteQoEh6BLNCiRHFufHYF95z6J/EMgeSE=";
  };

  robtkSrc = fetchFromGitHub {
    owner = "x42";
    repo = "robtk";
    rev = "v${robtkVersion}";
    sha256 = "sha256-zeRMobfKW0+wJwYVem74tglitkI6DSoK75Auywcu4Tw=";
  };

  postUnpack = ''
    rm -rf $sourceRoot/robtk/
    ln -s ${robtkSrc} $sourceRoot/robtk
  '';

  meter_VERSION = version;
  enableParallelBuilding = true;
  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with lib; {
    description = "Collection of audio level meters with GUI in LV2 plugin format";
    homepage = "https://x42.github.io/meters.lv2/";
    maintainers = with maintainers; [ ehmry ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
