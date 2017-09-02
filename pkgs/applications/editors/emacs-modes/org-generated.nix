{ callPackage }: {
    org = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org";
        version = "20170828";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-20170828.tar";
          sha256 = "0zvszxw9dm1j3jf1fblvfc74kmiv3zmjydlkkj7q4vd0p4gnfvky";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org.html";
          license = lib.licenses.free;
        };
      }) {};
    org-plus-contrib = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org-plus-contrib";
        version = "20170828";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-plus-contrib-20170828.tar";
          sha256 = "0r3n7ilf4aqsg9hl057qkl70s9bd9w5884ddigbiahv88hldvv4y";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }