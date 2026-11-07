{
  lib,
  stdenv,
  fetchFromGitLab,
  po4a,
  gettext,
  perl,
}:

stdenv.mkDerivation rec {
  pname = "man-pages-l10n";
  version = "4.25.1";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "manpages-l10n-team";
    repo = "manpages-l10n";
    rev = version;
    hash = "sha256-+l7jTyze9bbU0A1DUztljbnVgsqPdMkQ2Xb2De0k8J0=";
  };

  nativeBuildInputs = [
    po4a
    gettext
    perl
  ];

  preConfigure = ''
    patchShebangs .
  '';

  meta = {
    description = "Translations of man pages";
    homepage = "https://manpages-l10n-team.pages.debian.net/manpages-l10n/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ malte-v ];
    # if a package comes with its own man page translation, prefer it
    priority = 30;
  };
}
