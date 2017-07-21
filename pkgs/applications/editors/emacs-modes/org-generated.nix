{ callPackage }: {
    org = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org";
        version = "20170717";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-20170717.tar";
          sha256 = "1cbk01awnyan1jap184v2bxsk97k0p2qn19z7gnid6wiblybgs89";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org.html";
          license = lib.licenses.free;
        };
      }) {};
    org-plus-contrib = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org-plus-contrib";
        version = "20170717";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-plus-contrib-20170717.tar";
          sha256 = "0710ba6gq04cg8d87b5wi7bz9gq9yqvqmkmgscawfm2ynfw2q8sa";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }