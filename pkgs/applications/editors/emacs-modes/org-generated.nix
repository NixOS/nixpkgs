{ callPackage }: {
    org = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org";
        version = "20160725";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-20160725.tar";
          sha256 = "1d2v6w93z543jnmz6a1kmp61rmznjnw6pvd9ia2pm42rzhsgydy5";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org.html";
          license = lib.licenses.free;
        };
      }) {};
    org-plus-contrib = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org-plus-contrib";
        version = "20160725";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-plus-contrib-20160725.tar";
          sha256 = "0bxxbcln7npffvd947052sjp59ypxdfwkp2ja7mbs28pzzb25xxi";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }