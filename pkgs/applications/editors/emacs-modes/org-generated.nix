{ callPackage }: {
    org = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org";
        version = "20161102";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-20161102.tar";
          sha256 = "1mj100pnxskgrfmabj0vdmsijmr7v5ir7c18aypv92nh3fnmiz0f";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org.html";
          license = lib.licenses.free;
        };
      }) {};
    org-plus-contrib = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org-plus-contrib";
        version = "20161102";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-plus-contrib-20161102.tar";
          sha256 = "124rizp50jaqshcmrr7x2132x5sy7q81nfb37482j9wzrc9l7b95";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }