{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20210823";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20210823.tar";
          sha256 = "0yd2ydkkfy9lmlnb0lpsm8ywbk88sq9n4i7dasfzslv7czgccyh7";
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
        version = "20210823";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20210823.tar";
          sha256 = "17lyhsi22wg3l3j4k67glvq9p12r3nlc7fs6ka5jr2xrvfypb5aj";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }
