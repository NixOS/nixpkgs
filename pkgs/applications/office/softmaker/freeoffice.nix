{ callPackage
, fetchurl

  # This is a bit unusual, but makes version and hash easily
  # overridable. This is useful when the upstream archive was replaced
  # and nixpkgs is not in sync yet.
, officeVersion ? {
  version = "978";
  edition = "2018";
  sha256 = "1c5div1kbyyj48f89wkhc1i1759n70bsbp3w4a42cr0jmllyl60v";
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
