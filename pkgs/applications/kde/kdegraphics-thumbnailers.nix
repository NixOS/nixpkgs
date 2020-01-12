{
  mkDerivation, lib, fetchpatch,
  extra-cmake-modules, karchive, kio, libkexiv2, libkdcraw
}:

mkDerivation {
  name = "kdegraphics-thumbnailers";
  meta = {
    license = [ lib.licenses.lgpl21 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  patches = [
    # Fix a bug with thumbnail.so processes hanging:
    # https://bugs.kde.org/show_bug.cgi?id=404652
    (fetchpatch {
      url = "https://phabricator.kde.org/file/data/tnk4b6roouixzifi6vre/PHID-FILE-qkkedevt7svx7lv56ea5/D26635.diff";
      sha256 = "0fq85zhymmrq8vl0y6vgh87qf4c6fhcq704p4kpkaq7y0isxj4h1";
    })
  ];
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ karchive kio libkexiv2 libkdcraw ];
}
