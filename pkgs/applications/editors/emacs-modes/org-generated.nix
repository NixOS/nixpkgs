{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20210208";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20210208.tar";
          sha256 = "1awqk2dk3sgglq6fqgaz8y8rqw3p5rcnkp7i6m15n7wlq9nx7njp";
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
        version = "20210208";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20210208.tar";
          sha256 = "13yrzx7sdndf38hamm1m82kfgnqgm8752mjxmmqw1iqr3r33ihi3";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }
