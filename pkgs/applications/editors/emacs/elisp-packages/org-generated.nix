{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20210920";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20210920.tar";
          sha256 = "01b44npf0rxq7c4ddygc3n3cv3h7afs41az0nfs67a5x7ag6c1jj";
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
        version = "20210920";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20210920.tar";
          sha256 = "1m376fnm8hrm83hgx4b0y21lzdrbxjp83bv45plvrjky44qfdwfn";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }
