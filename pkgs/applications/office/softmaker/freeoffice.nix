{ callPackage
, fetchurl

  # This is a bit unusual, but makes version and hash easily
  # overridable. This is useful when the upstream archive was replaced
  # and nixpkgs is not in sync yet.
, officeVersion ? {
  version = "982";
  edition = "2018";
  hash = "sha256-euoZfAaDDTXzoaNLc/YdTngreTiYOBi7sGU161GP83w=";
}

, ... } @ args:

callPackage ./generic.nix (args // rec {
  inherit (officeVersion) version edition;

  pname = "freeoffice";
  suiteName = "FreeOffice";

  src = fetchurl {
    inherit (officeVersion) hash;
    url = "https://www.softmaker.net/down/softmaker-freeoffice-${version}-amd64.tgz";
  };

  archive = "freeoffice${edition}.tar.lzma";
})
