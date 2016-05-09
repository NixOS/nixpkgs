{ callPackage }: {
    org = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org";
        version = "20160502";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-20160502.tar";
          sha256 = "0ranc2qiw6g6qja0jh1dvh06k6waagkiir2q2zla5d54brw4fg5a";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org.html";
          license = lib.licenses.free;
        };
      }) {};
    org-plus-contrib = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org-plus-contrib";
        version = "20160502";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-plus-contrib-20160502.tar";
          sha256 = "1znqh4pp9dlqmmdjhgy6vb880hq3cl4q6nmv48x8n5may159mvm0";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }