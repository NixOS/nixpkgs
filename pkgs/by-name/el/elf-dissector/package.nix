{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  elfutils,
  kdePackages,
  libiberty,
  libdwarf,
  libopcodes,
  qt6,
  qt6Packages,
}:

stdenv.mkDerivation {
  pname = "elf-dissector";
  version = "0.0.1-unstable-2025-11-05";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "sdk";
    repo = "elf-dissector";
    rev = "37aa18d16e0f1a4fca5a276473ae37b2b93f623d";
    hash = "sha256-O9b6lgJt5SwTwIEohkYpwWxnN0R0w7oEZGrDgj3aGOs=";
  };

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
    qt6Packages.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qttools
    libiberty
    elfutils
    libopcodes
    libdwarf
  ];

  meta = {
    homepage = "https://invent.kde.org/sdk/elf-dissector";
    description = "Tools for inspecting, analyzing and optimizing ELF files";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.philiptaron ];
  };
}
