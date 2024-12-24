{
  callPackage,
  fetchurl,

  # This is a bit unusual, but makes version and hash easily
  # overridable. This is useful when the upstream archive was replaced
  # and nixpkgs is not in sync yet.
  officeVersion ? {
    version = "1220";
    edition = "2024";
    hash = "sha256-F1Srm3/4UPifYls21MhjbpxSyLaT0gEVzEMQF0gIzi0=";
  },

  ...
}@args:

callPackage ./generic.nix (
  args
  // rec {
    inherit (officeVersion) version edition;

    pname = "freeoffice";
    suiteName = "FreeOffice";

    src = fetchurl {
      inherit (officeVersion) hash;
      url = "https://www.softmaker.net/down/softmaker-freeoffice-${edition}-${version}-amd64.tgz";
    };

    archive = "freeoffice${edition}.tar.lzma";
  }
)
