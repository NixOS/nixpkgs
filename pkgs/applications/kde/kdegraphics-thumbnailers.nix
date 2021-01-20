{
  mkDerivation, lib, fetchpatch,
  extra-cmake-modules, karchive, kio, libkexiv2, libkdcraw
}:

mkDerivation {
  pname = "kdegraphics-thumbnailers";
  meta = {
    license = [ lib.licenses.lgpl21 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ karchive kio libkexiv2 libkdcraw ];
}
