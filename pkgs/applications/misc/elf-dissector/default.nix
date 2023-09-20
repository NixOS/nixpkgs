{ lib
, stdenv
, fetchgit
, cmake
, extra-cmake-modules
, wrapQtAppsHook
, kitemmodels
, libiberty
, libelf
, libdwarf
, libopcodes
}:

stdenv.mkDerivation rec {
  pname = "elf-dissector";
  version = "unstable-2023-06-06";

  src = fetchgit {
    url = "https://invent.kde.org/sdk/elf-dissector.git";
    rev = "de2e80438176b4b513150805238f3333f660718c";
    hash = "sha256-2yHPVPu6cncXhFCJvrSodcRFVAxj4vn+e99WhtiZniM=";
  };

  patches = [
    ./fix_build_for_src_lib_disassembler_disassembler.diff
  ];

  nativeBuildInputs = [ cmake extra-cmake-modules wrapQtAppsHook ];

  buildInputs = [ kitemmodels libiberty libelf libdwarf libopcodes ];

  meta = with lib; {
    homepage = "https://invent.kde.org/sdk/elf-dissector";
    description = "Tools for inspecting, analyzing and optimizing ELF files";
    license = licenses.gpl2;
    maintainers = with maintainers; [ ehmry ];
  };
}
