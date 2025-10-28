{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  elfutils,
  extra-cmake-modules,
  kitemmodels,
  libiberty,
  libdwarf,
  libopcodes,
  wrapQtAppsHook,
}:

stdenv.mkDerivation {
  pname = "elf-dissector";
  version = "unstable-2023-12-24";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "sdk";
    repo = "elf-dissector";
    rev = "613538bd1d87ce72d5115646551a49cf7ff2ee34";
    hash = "sha256-fQFGFw8nZHMs8J1W2CcHAJCdcvaY2l2/CySyBSsKpyE=";
  };

  patches = [
    ./fix_build_for_src_lib_disassembler_disassembler.diff
  ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    wrapQtAppsHook
  ];

  buildInputs = [
    kitemmodels
    libiberty
    elfutils
    libopcodes
    libdwarf
  ];

  meta = with lib; {
    homepage = "https://invent.kde.org/sdk/elf-dissector";
    description = "Tools for inspecting, analyzing and optimizing ELF files";
    license = licenses.gpl2;
    maintainers = with maintainers; [
      philiptaron
    ];
  };
}
