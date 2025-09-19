{
  callPackage,
  fetchurl,

  # This is a bit unusual, but makes version and hash easily
  # overridable. This is useful when the upstream archive was replaced
  # and nixpkgs is not in sync yet.
  officeVersion ? {
    version = "1228";
    edition = "";
    hash = "sha256-Va0QkLQtsPbDAo3ygfp6UKr0OkLLBS0yAup+xLoLD0s=";
  },

  ...
}@args:

callPackage ./generic.nix (
  args
  // rec {
    inherit (officeVersion) version edition;

    pname = "softmaker-office-nx";
    suiteName = "SoftMaker Office NX";

    src = fetchurl {
      inherit (officeVersion) hash;
      url = "https://www.softmaker.net/down/softmaker-office-nx-${version}-amd64.tgz";
    };

    archive = "officenx.tar.lzma";
  }
)
