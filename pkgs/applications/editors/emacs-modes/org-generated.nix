{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20200504";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20200504.tar";
          sha256 = "1nalr2jafhzfkaf4bn8kscxd7nm1wz7dbw2629j2msxknw76dwk1";
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
        version = "20200504";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20200504.tar";
          sha256 = "1ykw3qspz18jgf3ngsvk2ys282489fcjrbk7pbv3ppxzjha4rmhb";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }