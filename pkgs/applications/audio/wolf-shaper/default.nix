{ stdenv, fetchFromGitHub , libjack2, lv2, xorg, liblo, libGL, libXcursor, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "wolf-shaper";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "pdesaulniers";
    repo = "wolf-shaper";
    rev = "v${version}";
    sha256 = "0lllgcbnnh1m95bp29hh17x170hl7170zizjrvy892qfkn36830d";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libjack2 lv2 xorg.libX11 liblo libGL libXcursor  ];

  makeFlags = [
    "BUILD_LV2=true"
    "BUILD_DSSI=true"
    "BUILD_VST2=true"
    "BUILD_JACK=true"
  ];

  patchPhase = ''
    patchShebangs ./dpf/utils/generate-ttl.sh
  '';

  installPhase = ''
    mkdir -p $out/lib/lv2
    mkdir -p $out/lib/dssi
    mkdir -p $out/lib/vst
    mkdir -p $out/bin/
    cp -r bin/wolf-shaper.lv2    $out/lib/lv2/
    cp -r bin/wolf-shaper-dssi*  $out/lib/dssi/
    cp -r bin/wolf-shaper-vst.so $out/lib/vst/
    cp -r bin/wolf-shaper        $out/bin/
  '';

  meta = with stdenv.lib; {
    homepage = "https://pdesaulniers.github.io/wolf-shaper/";
    description = "Waveshaper plugin with spline-based graph editor";
    license = licenses.gpl3;
    maintainers = [ maintainers.magnetophon ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
