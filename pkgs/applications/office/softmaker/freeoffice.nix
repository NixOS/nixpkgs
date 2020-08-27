{ callPackage
, fetchurl

  # This is a bit unusual, but makes version and hash easily
  # overridable. This is useful when the upstream archive was replaced
  # and nixpkgs is not in sync yet.
, officeVersion ? {
  version = "976";
  edition = "2018";
  sha256 = "13yh4lyqakbdqf4r8vw8imy5gwpfva697iqfd85qmp3wimqvzskl";
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
