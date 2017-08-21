{ callPackage }: {
    org = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org";
        version = "20170814";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-20170814.tar";
          sha256 = "1r55vfjbll18h1nb5a48293x9lwmcmxgpx8h20n77n3inqmc6yli";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org.html";
          license = lib.licenses.free;
        };
      }) {};
    org-plus-contrib = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org-plus-contrib";
        version = "20170814";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-plus-contrib-20170814.tar";
          sha256 = "15v3944p1vnjqmy6il6gr1ipqw32cjzdq6w43rniwv2vr5lmh6iz";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }