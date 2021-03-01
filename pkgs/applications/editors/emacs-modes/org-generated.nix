{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20210301";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20210301.tar";
          sha256 = "0930km35lvbw89ifrqmcv96fjmp4fi12yv3spn51q27sfsmzqsrj";
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
        version = "20210301";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20210301.tar";
          sha256 = "11mwar5x848iwc1cdssr3vyx0amji840x6f0dmjpigngpcnj02m8";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }
