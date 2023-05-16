<<<<<<< HEAD
{ lib, stdenv, fetchFromGitHub, libjack2, lv2, xorg, liblo, libGL, libXcursor, pkg-config }:

stdenv.mkDerivation rec {
  pname = "wolf-shaper";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "wolf-plugins";
    repo = "wolf-shaper";
    rev = "v${version}";
    hash = "sha256-4oi1wnex6eNRHUWXZHnvrmqp4veFuPJqD0YuOhDepg4=";
=======
{ lib, stdenv, fetchFromGitHub , libjack2, lv2, xorg, liblo, libGL, libXcursor, pkg-config }:

stdenv.mkDerivation rec {
  pname = "wolf-shaper";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "pdesaulniers";
    repo = "wolf-shaper";
    rev = "v${version}";
    sha256 = "sha256-xy6ZebabTRLo/Xk2OMoR4xtxmZsqYXaUHUebuDrHOvA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkg-config ];
<<<<<<< HEAD
  buildInputs = [ libjack2 lv2 xorg.libX11 liblo libGL libXcursor ];
=======
  buildInputs = [ libjack2 lv2 xorg.libX11 liblo libGL libXcursor  ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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

  meta = with lib; {
<<<<<<< HEAD
    homepage = "https://wolf-plugins.github.io/wolf-shaper/";
    description = "Waveshaper plugin with spline-based graph editor";
    license = licenses.gpl3Plus;
=======
    homepage = "https://pdesaulniers.github.io/wolf-shaper/";
    description = "Waveshaper plugin with spline-based graph editor";
    license = licenses.gpl3;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = [ maintainers.magnetophon ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
