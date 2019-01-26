{ stdenv, fetchFromGitHub , libjack2, lv2, xorg, liblo, libGL, libXcursor, pkgconfig }:

stdenv.mkDerivation rec {
  name = "wolf-shaper-${version}";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "pdesaulniers";
    repo = "wolf-shaper";
    rev = "v${version}";
    sha256 = "01h5dm1nrr0i54ancwznr7wn4vpw08dw0b69v3axy32r5j7plw6s";
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
    homepage = https://pdesaulniers.github.io/wolf-shaper/;
    description = "Waveshaper plugin with spline-based graph editor";
    license = licenses.gpl3;
    maintainers = [ maintainers.magnetophon ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
