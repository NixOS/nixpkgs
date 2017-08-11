{ callPackage }: {
    org = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org";
        version = "20170807";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-20170807.tar";
          sha256 = "0cpkkfw7wmz242r5zzpcnzp7gfsmja90gqqb5h20azxmq96kfzga";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org.html";
          license = lib.licenses.free;
        };
      }) {};
    org-plus-contrib = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org-plus-contrib";
        version = "20170807";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-plus-contrib-20170807.tar";
          sha256 = "145j9g1lx5nj85irdh9ljhh4rhwj9ys8nnca549lyxd9a5yiav5k";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }