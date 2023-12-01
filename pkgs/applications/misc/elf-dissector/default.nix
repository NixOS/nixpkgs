{ lib
, stdenv
, fetchgit
, cmake
, elfutils
, extra-cmake-modules
, kitemmodels
, libiberty
, libdwarf
, libopcodes
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "elf-dissector";
  version = "unstable-2023-11-25";

  src = fetchgit {
    url = "https://invent.kde.org/sdk/elf-dissector.git";
    rev = "888ef6581df0400db45e0a7829a7336531b12641";
    sha256 = "sha256-V0cn3lAE5MSEUfiSY2q08ig/S1PWu9Scz558IVM97b0=";
  };

  patches = [
    ./fix_build_for_src_lib_disassembler_disassembler.diff
  ];

  nativeBuildInputs = [ cmake extra-cmake-modules wrapQtAppsHook ];

  buildInputs = [ kitemmodels libiberty elfutils libopcodes libdwarf ];

  meta = with lib; {
    homepage = "https://invent.kde.org/sdk/elf-dissector";
    description = "Tools for inspecting, analyzing and optimizing ELF files";
    license = licenses.gpl2;
    maintainers = with maintainers; [ ehmry ];
  };
}
