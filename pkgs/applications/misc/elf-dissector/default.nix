<<<<<<< HEAD
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
=======
{ mkDerivation, fetchgit, lib, cmake, extra-cmake-modules, kitemmodels
, libiberty, libelf, libdwarf, libopcodes }:

mkDerivation rec {
  pname = "elf-dissector";
  version = "unstable-2020-11-14";

  src = fetchgit {
    url = "https://invent.kde.org/sdk/elf-dissector.git";
    rev = "d1700e76e3f60aff0a2a9fb63bc001251d2be522";
    sha256 = "1h1xr3ag1sbf005drcx8g8dc5mk7fb2ybs73swrld7clcawhxnk8";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = [ kitemmodels libiberty libelf libdwarf libopcodes ];

  meta = with lib; {
    homepage = "https://invent.kde.org/sdk/elf-dissector";
    description = "Tools for inspecting, analyzing and optimizing ELF files";
    license = licenses.gpl2;
    maintainers = with maintainers; [ ehmry ];
  };
}
