{ lib, stdenv, fetchFromGitHub, obs-studio, cmake, qtbase }:

stdenv.mkDerivation rec {
  pname = "obs-multi-rtmp";
  version = "0.2.6.1";

  src = fetchFromGitHub {
    owner = "sorayuki";
    repo = "obs-multi-rtmp";
    rev = version;
    sha256 = "sha256-ZcvmiE9gbDUHAO36QAIaUdjV14ZfPabD9CW7Ogeqdro=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ obs-studio qtbase ];

  cmakeFlags = [
    "-DLIBOBS_INCLUDE_DIR=${obs-studio}/include/obs"
  ];

  dontWrapQtApps = true;

  meta = with lib; {
    homepage = "https://github.com/sorayuki/obs-multi-rtmp/";
    changelog = "https://github.com/sorayuki/obs-multi-rtmp/releases/tag/${version}";
    description = "Multi-site simultaneous broadcast plugin for OBS Studio";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ jk ];
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
