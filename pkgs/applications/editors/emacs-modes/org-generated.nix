{ callPackage }: {
    org = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org";
        version = "20170724";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-20170724.tar";
          sha256 = "07rpr8zf12c62sfbk9c9lvvfphs3ws136d3vlnq6j7gypdzyb32m";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org.html";
          license = lib.licenses.free;
        };
      }) {};
    org-plus-contrib = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org-plus-contrib";
        version = "20170724";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-plus-contrib-20170724.tar";
          sha256 = "12xgvdmpz6wnylcvfngh7lqvgs9wv1bdrm7l7fivakx8y3dyq7k7";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }