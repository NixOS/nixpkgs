{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  obs-studio,
  pipewire,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "obs-pipewire-audio-capture";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "dimtpap";
    repo = pname;
    rev = version;
    sha256 = "sha256-qYHU0m+jz/mQmjleITnzxNkTio5ir8dFkHKfmY4l0Es=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];
  buildInputs = [
    obs-studio
    pipewire
  ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=/lib"
  ];

  meta = with lib; {
    description = "Audio device and application capture for OBS Studio using PipeWire";
    homepage = "https://github.com/dimtpap/obs-pipewire-audio-capture";
    maintainers = with maintainers; [ Elinvention ];
    license = licenses.gpl2Plus;
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
  };
}
