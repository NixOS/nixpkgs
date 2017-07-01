{ callPackage }: {
    org = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org";
        version = "20170622";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-20170622.tar";
          sha256 = "0z4ypv6q4nx4icir69xchzn58xzndnxlkg0v4pb62gqghdxng6vy";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org.html";
          license = lib.licenses.free;
        };
      }) {};
    org-plus-contrib = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org-plus-contrib";
        version = "20170622";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-plus-contrib-20170622.tar";
          sha256 = "0ix4gmr6y9nrna9sc9cy30533mxlnvlfnf25492ky6dkssbxb10s";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }