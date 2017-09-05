{ callPackage }: {
    org = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org";
        version = "20170904";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-20170904.tar";
          sha256 = "1d0w3mmxdsfiwvpbc2ip21jxqlag0gk05214h86w52y9ymj0jbll";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org.html";
          license = lib.licenses.free;
        };
      }) {};
    org-plus-contrib = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org-plus-contrib";
        version = "20170904";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-plus-contrib-20170904.tar";
          sha256 = "1iz0xk5s5d6gpfxb3k2fz3xbrn5rhxnvkq69c5dbrfdk67rm7q4k";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }