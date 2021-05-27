{ callPackage
, fetchurl

  # This is a bit unusual, but makes version and hash easily
  # overridable. This is useful when people have an older version of
  # Softmaker Office or when the upstream archive was replaced and
  # nixpkgs is not in sync yet.
, officeVersion ? {
  version = "982";
  edition = "2018";
  hash = "sha256-A45q/irWxKTLszyd7Rv56WeqkwHtWg4zY9YVxqA/KmQ=";
}

, ... } @ args:

callPackage ./generic.nix (args // rec {
  inherit (officeVersion) version edition;

  pname = "softmaker-office-2018";
  suiteName = "SoftMaker Office 2018";

  src = fetchurl {
    inherit (officeVersion) hash;
    url = "https://www.softmaker.net/down/softmaker-office-${edition}-${version}-amd64.tgz";
  };

  archive = "office${edition}.tar.lzma";
})
