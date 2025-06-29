{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  gettext,
  libiconv,
}:

stdenv.mkDerivation rec {
  pname = "html2text";
  version = "2.2.3";

  src = fetchFromGitLab {
    owner = "grobian";
    repo = "html2text";
    rev = "v${version}";
    hash = "sha256-7Ch51nJ5BeRqs4PEIPnjCGk+Nm2ydgJQCtkcpihXun8=";
  };

  nativeBuildInputs = [
    autoreconfHook
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
