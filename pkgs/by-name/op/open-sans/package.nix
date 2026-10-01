{
  lib,
  stdenvNoCC,
  fetchFromGitLab,
  installFonts,
}:

stdenvNoCC.mkDerivation {
  pname = "open-sans";
  version = "1.11";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "fonts-team";
    repo = "fonts-open-sans";
    tag = "debian/1.11-1";
    hash = "sha256-gkq5RPa83dND91q1hiA9Qokq1iA8gLQ8XvCNWe+e8Bw=";
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    description = "Open Sans fonts";
    longDescription = ''
      Open Sans is a humanist sans serif typeface designed by Steve Matteson,
      Type Director of Ascender Corp.
    '';
    homepage = "https://www.opensans.com";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    teams = [ lib.teams.pantheon ];
  };
}
