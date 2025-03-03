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
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "dimtpap";
    repo = pname;
    rev = version;
    sha256 = "sha256-nkd/AoMsEUUxQQH5CjbnPbNwAwkd1y6j2nCa1GIAFPs=";
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
    "-DCMAKE_INSTALL_LIBDIR=./lib"
    "-DCMAKE_INSTALL_DATADIR=./usr"
  ];

  meta = with lib; {
    description = "Audio device and application capture for OBS Studio using PipeWire";
    homepage = "https://github.com/dimtpap/obs-pipewire-audio-capture";
    maintainers = with maintainers; [
      Elinvention
      fazzi
    ];
    license = licenses.gpl2Plus;
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
  };
}
