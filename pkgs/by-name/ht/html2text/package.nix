{
  lib,
  stdenv,
  fetchFromGitLab,
  autoconf-archive,
  autoreconfHook,
  bison,
  gettext,
  libiconv,
}:

stdenv.mkDerivation rec {
  pname = "html2text";
  version = "2.3.0";

  src = fetchFromGitLab {
    owner = "grobian";
    repo = "html2text";
    rev = "v${version}";
    hash = "sha256-e/KWyc7lOdWhtFC7ZAD7sYgCsO3JzGkLUThVI7edqIQ=";
  };

  nativeBuildInputs = [
    autoconf-archive
    autoreconfHook
    bison
    gettext
  ];

  # These changes have all been made in HEAD, across several commits
  # amongst other changes.
  # See https://gitlab.com/grobian/html2text/-/merge_requests/57
  patches = [ ./gettext-0.25.patch ];

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin libiconv;

  meta = {
    description = "Convert HTML to plain text";
    mainProgram = "html2text";
    homepage = "https://gitlab.com/grobian/html2text";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.eikek ];
  };
}
