{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20210719";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20210719.tar";
          sha256 = "1aravj0krdi8bnfinfj1d92vq3g06djxcnpipibkrw9ggk0d01d6";
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
        version = "20210719";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20210719.tar";
          sha256 = "1knjkf365cnjd8sdhaisjx0n6n0l2zfpql1b2gzw0gj62kbpl476";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }
