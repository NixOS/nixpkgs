{ callPackage }: {
    org = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org";
        version = "20161224";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-20161224.tar";
          sha256 = "15fnc65k5mn5ssl53z4f9nlkz5m8a59zkaripcapdcq87ys5imqm";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org.html";
          license = lib.licenses.free;
        };
      }) {};
    org-plus-contrib = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org-plus-contrib";
        version = "20161224";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-plus-contrib-20161224.tar";
          sha256 = "1pj3h5qllhcqyqvm2kln7056m34k5flipvslnn1rvsk4iwwjlv1a";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }