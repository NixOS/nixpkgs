{ callPackage }: {
    org = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org";
        version = "20170502";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-20170502.tar";
          sha256 = "1y5rdf6740z45v75y17yh3a1ivdk5fjrax3hyr11jydyicczk4h1";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org.html";
          license = lib.licenses.free;
        };
      }) {};
    org-plus-contrib = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org-plus-contrib";
        version = "20170502";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-plus-contrib-20170502.tar";
          sha256 = "06pr3w11zpns66km27ql3w8qlk6bxaxqx3bmaiwrxykhbf74dib0";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }