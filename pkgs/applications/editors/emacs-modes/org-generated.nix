{ callPackage }: {
    org = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org";
        version = "20180102";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20180102.tar";
          sha256 = "1jz92wv637x1kp726kgcc29s4s4rscfhb7rhhnr69ny83r1hlczi";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org.html";
          license = lib.licenses.free;
        };
      }) {};
    org-plus-contrib = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org-plus-contrib";
        version = "20180102";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20180102.tar";
          sha256 = "02ajqc8k44w2gskjazkglmn2v0jsxfns0wq3pgslhb7ychs3yrlv";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }