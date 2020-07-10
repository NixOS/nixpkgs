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
      url = "https://github.com/KDE/kdegraphics-thumbnailers/commit/3e2ea6e924d0e2a2cdd9bb435b06965117d6d34c.patch";
      sha256 = "0fq85zhymmrq8vl0y6vgh87qf4c6fhcq704p4kpkaq7y0isxj4h1";
    })
  ];
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ karchive kio libkexiv2 libkdcraw ];
}
