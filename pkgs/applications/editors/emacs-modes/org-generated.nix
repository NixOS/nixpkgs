{ callPackage }: {
    org = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org";
        version = "20180122";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20180122.tar";
          sha256 = "0a3a5v5x43xknqc6m5rcgdsqlw047w1djq372akfn5wafsk8a916";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org.html";
          license = lib.licenses.free;
        };
      }) {};
    org-plus-contrib = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org-plus-contrib";
        version = "20180122";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20180122.tar";
          sha256 = "1ss6h03xkvgk2qm1dx4dxxxalbswjc1jl9v87q99nls8iavmqa8x";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }