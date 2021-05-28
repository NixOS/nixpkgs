{ callPackage
, fetchurl

  # This is a bit unusual, but makes version and hash easily
  # overridable. This is useful when people have an older version of
  # Softmaker Office or when the upstream archive was replaced and
  # nixpkgs is not in sync yet.
, officeVersion ? {
  version = "1020";
  edition = "2021";
  sha256 = "1v227pih1p33x7axsw7wz8pz5walpbqnk0iqng711ixk883nqxn5";
}

, ... } @ args:

callPackage ./generic.nix (args // rec {
  inherit (officeVersion) version edition;

  pname = "softmaker-office";
  suiteName = "SoftMaker Office";

  src = fetchurl {
    inherit (officeVersion) sha256;
    url = "https://www.softmaker.net/down/softmaker-office-${edition}-${version}-amd64.tgz";
  };

  archive = "office${edition}.tar.lzma";
})
