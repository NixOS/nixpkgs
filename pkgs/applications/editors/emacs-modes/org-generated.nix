{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20201228";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20201228.tar";
          sha256 = "0rv98v3zbdbc4yfq9mymrxrcj422xpfhvw31xrspydwgpxqgsf99";
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
        version = "20201228";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20201228.tar";
          sha256 = "0libzh2a51m9l0kb01zjw2fai2nbxqw9r01i8fkjy94hq0lbw7cc";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }
