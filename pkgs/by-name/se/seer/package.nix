{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gdb,
  kdePackages,
}:

stdenv.mkDerivation rec {
  pname = "seer";
  version = "2.8";

  src = fetchFromGitHub {
    owner = "epasveer";
    repo = "seer";
    rev = "v${version}";
    sha256 = "sha256-PlIA9N80EfKe7/EXYw3V3att9Qv6VHsm4mNzG2dyq/o=";
  };

  preConfigure = ''
    cd src
  '';

  patchPhase = ''
    substituteInPlace src/{SeerGdbConfigPage,SeerMainWindow,SeerGdbWidget}.cpp \
      --replace-fail "/usr/bin/gdb" "${gdb}/bin/gdb"
  '';

  buildInputs = with kdePackages; [
    qtbase
    qtcharts
    qtsvg
  ];
  nativeBuildInputs = [
    cmake
    kdePackages.wrapQtAppsHook
  ];

  meta = {
    description = "Qt gui frontend for GDB";
    mainProgram = "seergdb";
    homepage = "https://github.com/epasveer/seer";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ foolnotion ];
  };
}
