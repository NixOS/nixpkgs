{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20210726";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20210726.tar";
          sha256 = "0bz5dwnknxb5mwb3rk6ckwq8a5imd2cjsx40ql9p9vc0c8rirqd4";
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
        version = "20210726";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20210726.tar";
          sha256 = "0fxjmb1773skyq76qmgx1jqfcglxrxxxqysqiirm48cc6yf13kp7";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }
