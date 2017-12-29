{ callPackage }: {
    org = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org";
        version = "20171106";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-20171106.tar";
          sha256 = "080zkrbivd0y67ydcqj97c672q6d9d33qgb5z723niy8a8xjrp20";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org.html";
          license = lib.licenses.free;
        };
      }) {};
    org-plus-contrib = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org-plus-contrib";
        version = "20171106";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-plus-contrib-20171106.tar";
          sha256 = "1ckh7q7kc72qc1wh4xypfadj9dpnn4xzc6ap4gg428q85bi091h1";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }