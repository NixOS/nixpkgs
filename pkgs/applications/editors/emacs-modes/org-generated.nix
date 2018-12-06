{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20181119";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-20181119.tar";
          sha256 = "0li6mx0kv70js3mlw7wxk1yi8kgc3nxnb87kdb7jy68xh4lsila7";
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
        version = "20181119";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-plus-contrib-20181119.tar";
          sha256 = "0dz0vn2xyidifrwrd604yknyq843i31jcc8qgsi6wib29rh7zzpa";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }