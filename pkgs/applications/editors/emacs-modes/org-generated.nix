{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20201207";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20201207.tar";
          sha256 = "0hryicg3nbvc17ypwdcx08kl8samd979388hw7jwbp5sw3v95y0c";
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
        version = "20201207";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20201207.tar";
          sha256 = "07xmnxrn63ini3c8hfrgv13b28dh91x2lpf875fhi5wz70w0a9s4";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }
