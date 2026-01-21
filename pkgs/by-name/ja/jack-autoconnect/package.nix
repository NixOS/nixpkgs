{
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  libjack2,
  libsForQt5,
}:
stdenv.mkDerivation {
  pname = "jack_autoconnect";

  # It does not have any versions (yet?)
  version = "unstable-2021-02-01";

  src = fetchFromGitHub {
    owner = "kripton";
    repo = "jack_autoconnect";
    rev = "fe0c8f69149e30979e067646f80b9d326341c02b";
    hash = "sha256-imvNc498Q2W9RKmiOoNepSoJzIv2tGvFG6hx+seiifw=";
  };

  buildInputs = [
    libsForQt5.qtbase
    libjack2
  ];

  nativeBuildInputs = [
    pkg-config
    libsForQt5.qmake
    libsForQt5.wrapQtAppsHook
  ];

  installPhase = ''
    mkdir -p -- "$out/bin"
    cp -- jack_autoconnect "$out/bin"
  '';

  meta = {
    homepage = "https://github.com/kripton/jack_autoconnect";
    description = "Tiny application that reacts on port registrations by clients and connects them";
    mainProgram = "jack_autoconnect";
    maintainers = with lib.maintainers; [ unclechu ];
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
  };
}
