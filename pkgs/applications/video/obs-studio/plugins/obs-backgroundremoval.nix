{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, obs-studio
, onnxruntime
, opencv
}:

stdenv.mkDerivation rec {
  pname = "obs-backgroundremoval";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "royshil";
    repo = "obs-backgroundremoval";
    rev = "v${version}";
    sha256 = "sha256-TI1FlhE0+JL50gAZCSsI+g8savX8GRQkH3jYli/66hQ=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ obs-studio onnxruntime opencv ];

  dontWrapQtApps = true;

  cmakeFlags = [
    "-DLIBOBS_INCLUDE_DIR=${obs-studio.src}/libobs"
    "-DOnnxruntime_INCLUDE_DIRS=${onnxruntime.dev}/include/onnxruntime/core/session"
  ];

  patches = [ ./obs-backgroundremoval-includes.patch ];

  prePatch = ''
    sed -i 's/version_from_git()/set(VERSION "${version}")/' CMakeLists.txt
  '';

  meta = with lib; {
    description = "OBS plugin to replace the background in portrait images and video";
    homepage = "https://github.com/royshil/obs-backgroundremoval";
    maintainers = with maintainers; [ puffnfresh ];
    license = licenses.mit;
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
