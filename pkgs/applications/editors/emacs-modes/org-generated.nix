{ callPackage }: {
    org = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org";
        version = "20171030";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-20171030.tar";
          sha256 = "1g2dyzy1844lli2hhfjnbskn1mskccgaaf0mxb1cm0zhhas8bnfd";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org.html";
          license = lib.licenses.free;
        };
      }) {};
    org-plus-contrib = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org-plus-contrib";
        version = "20171030";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-plus-contrib-20171030.tar";
          sha256 = "0pq2hs5d2i6s036pcs0jn6ld2p1ap08dmbjf17hsh899741mg9cj";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }