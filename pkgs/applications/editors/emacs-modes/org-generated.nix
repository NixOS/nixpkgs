{ callPackage }: {
    org = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org";
        version = "20171127";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-20171127.tar";
          sha256 = "0q9mbkyridz6zxkpcm7yk76iyliij1wy5sqqpcd8s6y5zy52zqwl";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org.html";
          license = lib.licenses.free;
        };
      }) {};
    org-plus-contrib = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org-plus-contrib";
        version = "20171127";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-plus-contrib-20171127.tar";
          sha256 = "0759g1lnwm9fz130cigvq5y4gigbk3wdc5yvz34blnl57ghir2k8";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }