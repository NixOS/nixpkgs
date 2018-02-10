{ callPackage }: {
    org = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org";
        version = "20180205";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20180205.tar";
          sha256 = "03045w9pr45byrj7wqzkb6i56d4r7xykfr066qmywspk764wmfyh";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org.html";
          license = lib.licenses.free;
        };
      }) {};
    org-plus-contrib = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org-plus-contrib";
        version = "20180205";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20180205.tar";
          sha256 = "0pbs3b0miqmpjw3d6mcw61dqyy6gnpdq6m18xmkbfvk5nn9lv7i6";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }