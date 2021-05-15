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

  buildInputs = [ kitemmodels libiberty libelf libdwarf libopcodes ];

  meta = with lib; {
    homepage = "https://invent.kde.org/sdk/elf-dissector";
    description = "Tools for inspecting, analyzing and optimizing ELF files";
    license = licenses.gpl2;
    maintainers = with maintainers; [ ehmry ];
  };
}
