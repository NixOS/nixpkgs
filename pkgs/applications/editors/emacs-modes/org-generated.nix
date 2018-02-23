{ callPackage }: {
    org = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org";
        version = "20180219";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20180219.tar";
          sha256 = "0yqyvkcal74jmpj6zl7xkcn85hdw2qpqjisb4dbdsr4312g45f3d";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org.html";
          license = lib.licenses.free;
        };
      }) {};
    org-plus-contrib = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org-plus-contrib";
        version = "20180219";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20180219.tar";
          sha256 = "1y7c2prbxpka0j32jam4fbfpslsh9h5049xbxfqymih456j8q7s2";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }