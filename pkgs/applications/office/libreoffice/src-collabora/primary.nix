{ fetchFromGitHub, fetchurl }:

rec {
  major = "6";
  minor = "2";
  patch = "10";
  tweak = "3";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchFromGitHub {
    owner = "libreoffice";
    repo = "core";
    rev = "CODE-4.2.0-3";
    sha256 = "0mnxgfyqscx573p2salsiz1nspzw9zamcniv7wzz8mm96s6s9qx0";
  };

  # fetchGitHub unpacks the archive as well which is already done in postUnpack
  translations = fetchurl {
    name = "libreoffice-translations";
    url = "https://github.com/libreoffice/translations/archive/a06c7f48d88361349bd0500fcccc8310197f9e8d.tar.gz";
    sha256 = "1mv26fyw63cx021pa2v1dil1zbv66kad3y29jkkqapv6wl863dxh";
    passthru.stripLevels = 1; # regular release tarballs have one more directory level
  };

  help = fetchurl {
    name = "libreoffice-help";
    url = "https://github.com/libreoffice/help/archive/630c355b9bb5f94ac9bd98d98f066730ae94fb2a.tar.gz";
    sha256 = "0rvsm1w4fclyi9q9z3335ddixfpw4im02dwxhafn1qf8dx08hscj";
    passthru.stripLevels = 1; # regular release tarballs have one more directory level
  };

  pname = "collaboraoffice";

  brandingDeb = fetchurl {
    url = "https://www.collaboraoffice.com/repos/CollaboraOnline/CODE/code-brand_4.2-17_all.deb";
    sha256 = "1acybhh6szybldc9wi2fx510bh1wb0416j4zzv5k7lrccy48jbz2";
  };
}
