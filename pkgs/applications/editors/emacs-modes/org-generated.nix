{ callPackage }: {
    org = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org";
        version = "20180129";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-20180129.tar";
          sha256 = "0cwxqr34c77qmv7flcpd46qwkn0nzli21s3m9km00mwc8xy308n4";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org.html";
          license = lib.licenses.free;
        };
      }) {};
    org-plus-contrib = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org-plus-contrib";
        version = "20180129";
        src = fetchurl {
          url = "https://orgmode.org/elpa/org-plus-contrib-20180129.tar";
          sha256 = "1bk7jmizlvfbq2bbis3kal8nllxj752a8dkq7j68q6kfbc6w1z24";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }