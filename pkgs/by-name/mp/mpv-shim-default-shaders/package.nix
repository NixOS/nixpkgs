{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "mpv-shim-default-shaders";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "iwalton3";
    repo = "default-shader-pack";
    rev = "v${version}";
    sha256 = "sha256-BM2GvmUoWQUUMH464YIIqu5A1t1B+otbJxAGFbySuq8=";
  };

  installPhase = ''
    mkdir -p $out/share/${pname}
    cp -r shaders *.json $out/share/${pname}
  '';

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/iwalton3/default-shader-pack";
    description = "Preconfigured set of MPV shaders and configurations for MPV Shim media clients";
    license = with lib.licenses; [
=======
  meta = with lib; {
    homepage = "https://github.com/iwalton3/default-shader-pack";
    description = "Preconfigured set of MPV shaders and configurations for MPV Shim media clients";
    license = with licenses; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      gpl3Plus
      mit
      unlicense
    ];
<<<<<<< HEAD
    maintainers = with lib.maintainers; [ devusb ];
=======
    maintainers = with maintainers; [ devusb ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
