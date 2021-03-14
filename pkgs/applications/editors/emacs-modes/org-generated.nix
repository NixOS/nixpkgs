{ callPackage }:
  {
    org = callPackage ({ elpaBuild, fetchurl, lib }:
      elpaBuild {
        pname = "org";
        ename = "org";
        version = "20210308";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20210308.tar";
          sha256 = "1i5zga615inn5s547329g6paqbzcbhyj9hxv14c0c1m9bhra5bjs";
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
        version = "20210308";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20210308.tar";
          sha256 = "1agbxhjkkmf4p8p8mwc6sv77ij22dr5fyhkpsnljvzkidiarfldf";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }
