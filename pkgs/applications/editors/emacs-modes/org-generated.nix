{ callPackage }: {
    org = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org";
        version = "20170606";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-20170606.tar";
          sha256 = "11x6s30j6k0y3jfzcp16qyqn48mki9j18iblnpl5dr1bk8kyvd0x";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org.html";
          license = lib.licenses.free;
        };
      }) {};
    org-plus-contrib = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org-plus-contrib";
        version = "20170606";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-plus-contrib-20170606.tar";
          sha256 = "0r6a5spzdbx6qdz5aziycmhjxm392v7iifv7mnln4s5lgnsswb1h";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }