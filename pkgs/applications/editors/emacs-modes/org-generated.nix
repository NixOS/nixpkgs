{ callPackage }: {
    org = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org";
        version = "20160905";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-20160905.tar";
          sha256 = "01zm7s5qbh1xvxddd93i6cmz3m7x2s67zwzah5q5l3hgnvbx750q";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org.html";
          license = lib.licenses.free;
        };
      }) {};
    org-plus-contrib = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org-plus-contrib";
        version = "20160905";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-plus-contrib-20160905.tar";
          sha256 = "1wx51iqg1cfrf220yslp2lq9s7klbv6bbxq0d2ygj47yjikkf39r";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }