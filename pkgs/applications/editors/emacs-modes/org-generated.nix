{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20210322";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20210322.tar";
          sha256 = "0iv54rhwa0972yr1wqzmlkggs5vc6qajz8mmyfhynp65ap088g6v";
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
        version = "20210322";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20210322.tar";
          sha256 = "0riswc3ira8hsawm37yypji55z47bw2477kaw3qx7ghz3n62r9nf";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }
