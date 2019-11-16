{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20190904";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-20190904.tar";
          sha256 = "0ah5zgbxp4j3mfgriw9liamy73npp9zbkq0zrg6cfhf8l3xwbnxn";
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
        version = "20190904";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-plus-contrib-20190904.tar";
          sha256 = "08s3fk3jim0y2v00l6ah8y08ba8wbcf29z6fxqzyaxj58a5sq81a";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }
