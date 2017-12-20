{ callPackage }: {
    org = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org";
        version = "20171218";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-20171218.tar";
          sha256 = "01w09hl1l03bxa31af6k433h6i2cwaxwd1v6n87zjnbwwlli2la6";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org.html";
          license = lib.licenses.free;
        };
      }) {};
    org-plus-contrib = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org-plus-contrib";
        version = "20171218";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-plus-contrib-20171218.tar";
          sha256 = "1dndmv99sjl2nknlj76235yygdpwgq61gp3mqgsihjyr9irsp58d";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }