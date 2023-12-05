{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, libdrm
, libvncserver
, libxkbcommon
, libva
}:

stdenv.mkDerivation rec {
  pname = "kmsvnc";
  version = "0.0.5";

  src = fetchFromGitHub {
    owner = "isjerryxiao";
    repo = "kmsvnc";
    rev = "v${version}";
    hash = "sha256-Dz1y4t8u9/rnmOiYMWMq6aEq3kV47uiIK7K4DSvjZNc=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libdrm
    libvncserver
    libxkbcommon
    libva
  ];

  meta = with lib; {
    description = "A VNC server for DRM/KMS capable GNU/Linux devices";
    homepage = "https://github.com/isjerryxiao/kmsvnc";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nickcao ];
    mainProgram = "kmsvnc";
    platforms = platforms.linux;
  };
}
