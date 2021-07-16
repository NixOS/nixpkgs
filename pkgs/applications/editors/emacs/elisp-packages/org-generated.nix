{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20210712";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20210712.tar";
          sha256 = "0xdxzfk7hvsmlyivn61ivci6hy2alxg2ysdm5xad4xxz337jrj7x";
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
        version = "20210712";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20210712.tar";
          sha256 = "1cdpwsfjmjplyik1r9kl4lvd5lm52zrixlfg2ml1mhh28s680k0q";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }
