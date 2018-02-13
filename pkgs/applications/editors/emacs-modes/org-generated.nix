{ callPackage }: {
    org = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org";
        version = "20180212";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20180212.tar";
          sha256 = "09wgmiavby009mkc5v2d0znrrs40fnmhzq252hni4zjy8kbgwfzk";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org.html";
          license = lib.licenses.free;
        };
      }) {};
    org-plus-contrib = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org-plus-contrib";
        version = "20180212";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20180212.tar";
          sha256 = "0wy9j2iagjzzjkqfsz1askxg4jmaxc0p0f42jbzx2ja7h4qkm9nj";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }