{ callPackage }: {
    org = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org";
        version = "20170731";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-20170731.tar";
          sha256 = "0lphzjxmk5y9g6b9rnacc9z55hbws3xmycsqdvsz56xr3aawx255";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org.html";
          license = lib.licenses.free;
        };
      }) {};
    org-plus-contrib = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org-plus-contrib";
        version = "20170731";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-plus-contrib-20170731.tar";
          sha256 = "1bba4m9r598f9l8wmr1j670d1qp4fcbbhzp9m4qd2md09rm3nsnw";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }