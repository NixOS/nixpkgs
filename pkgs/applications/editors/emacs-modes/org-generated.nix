{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20210315";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20210315.tar";
          sha256 = "128agds82kfmvxshzrs61802vgwlf2dsm79hq9x2bljrnvf8p14l";
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
        version = "20210315";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20210315.tar";
          sha256 = "0dih4690pbbnwlphjnv1kgvsw43pkcgk41xjjiphy9sf7w9gr11j";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }
