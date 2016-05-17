{ callPackage }: {
    org = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org";
        version = "20160516";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-20160516.tar";
          sha256 = "0zr87i55l92n1m8fgzvpdm40gh4fjwzsvgq47cmviqjr38kzdxv0";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org.html";
          license = lib.licenses.free;
        };
      }) {};
    org-plus-contrib = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org-plus-contrib";
        version = "20160516";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-plus-contrib-20160516.tar";
          sha256 = "1g1a9qsn1i1fh5ppa2jimfqvzkd7rhq5a7xz73lkaw8j3niqy62s";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }