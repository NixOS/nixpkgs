{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20210412";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20210412.tar";
          sha256 = "17hj4y0c9hjqqa7inzjadz9z64vh621lm4cb0asm13r7d1v186yf";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org.html";
          license = lib.licenses.free;
        };
      }) {};
    org-plus-contrib = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org-plus-contrib";
        ename = "org-plus-contrib";
        version = "20210412";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20210412.tar";
          sha256 = "162nl1a62l9d4nazply93sx4lih11845z87hxmpfd0n7i7s290mh";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }
