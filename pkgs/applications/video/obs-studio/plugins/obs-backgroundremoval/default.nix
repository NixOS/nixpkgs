{ lib
, stdenv
, fetchFromGitHub
, cmake
, obs-studio
, onnxruntime
, opencv
}:

stdenv.mkDerivation rec {
  pname = "obs-backgroundremoval";
  version = "unstable-2022-05-02";

  src = fetchFromGitHub {
    owner = "royshil";
    repo = "obs-backgroundremoval";
    rev = "cc9d4a5711f9388ed110230f9f793bb071577a23";
    hash = "sha256-xkVZ4cB642p4DvZAPwI2EVhkfVl5lJhgOQobjNMqpec=";
  };

  patches = [
    # Fix c++ include directives
    ./includes.patch

    # Use CPU backend instead of CUDA/DirectML
    ./use-cpu-backend.patch
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ obs-studio onnxruntime opencv ];

  dontWrapQtApps = true;

  cmakeFlags = [
    "-DLIBOBS_INCLUDE_DIR=${obs-studio.src}/libobs"
    "-DOnnxruntime_INCLUDE_DIRS=${onnxruntime.dev}/include/onnxruntime/core/session"
  ];


  prePatch = ''
    sed -i 's/version_from_git()/set(VERSION "0.4.0")/' CMakeLists.txt
  '';

  meta = with lib; {
    description = "OBS plugin to replace the background in portrait images and video";
    homepage = "https://github.com/royshil/obs-backgroundremoval";
    maintainers = with maintainers; [ puffnfresh ];
    license = licenses.mit;
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
