{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20190527";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-20190527.tar";
          sha256 = "1fc2nyylzpikjikyb24xq2mcilridcahmjwmg0s426dqrgqpm9ij";
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
        version = "20190527";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-plus-contrib-20190527.tar";
          sha256 = "16kf47ij25fijf6pbfxzq9xzildj1asdzhnkf5zv5pn4312pvgnq";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }
