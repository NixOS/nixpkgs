{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20210929";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20210929.tar";
          sha256 = "1fxhxjy48jxvs16x7270c4qj6n4lm952sn7q369c88gbf2jqxis4";
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
        version = "20210929";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20210929.tar";
          sha256 = "0bn80kji2h423d39c0am2r3p2hwvdxs9rm31xa4810dff27ihxb1";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }
