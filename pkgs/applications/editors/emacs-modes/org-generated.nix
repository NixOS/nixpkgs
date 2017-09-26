{ callPackage }: {
    org = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org";
        version = "20170911";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-20170911.tar";
          sha256 = "16d69g1qnfcj7d2q9ni5dz5wh9pid9mzhwyfg4z93s9xizzlnw64";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org.html";
          license = lib.licenses.free;
        };
      }) {};
    org-plus-contrib = callPackage ({ elpaBuild, fetchurl, lib }: elpaBuild {
        pname = "org-plus-contrib";
        version = "20170911";
        src = fetchurl {
          url = "http://orgmode.org/elpa/org-plus-contrib-20170911.tar";
          sha256 = "0bgrsccar4v9viq99w2h4rjavql14zgdwkwaa1bprga3af78jr82";
        };
        packageRequires = [];
        meta = {
          homepage = "https://elpa.gnu.org/packages/org-plus-contrib.html";
          license = lib.licenses.free;
        };
      }) {};
  }