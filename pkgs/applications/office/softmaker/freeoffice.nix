{ callPackage
, fetchurl

  # This is a bit unusual, but makes version and hash easily
  # overridable. This is useful when the upstream archive was replaced
  # and nixpkgs is not in sync yet.
, officeVersion ? {
  version = "980";
  edition = "2018";
  sha256 = "19pgil86aagiz6z4kx22gd4cxbbmrx42ix42arkfb6p6hav1plby";
}

, ... } @ args:

callPackage ./generic.nix (args // rec {
  inherit (officeVersion) version edition;

  pname = "freeoffice";
  suiteName = "FreeOffice";

  src = fetchurl {
    inherit (officeVersion) sha256;
    url = "https://www.softmaker.net/down/softmaker-freeoffice-${version}-amd64.tgz";
  };

  archive = "freeoffice${edition}.tar.lzma";
})
