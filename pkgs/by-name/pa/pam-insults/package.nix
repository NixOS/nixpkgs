{
  lib,
  stdenv,
  fetchFromGitHub,
  asciidoctor,
  gzip,
  pam,
  gettext,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pam-insults";
  version = "0.2.2-unstable-2025-12-19";

  src = fetchFromGitHub {
    owner = "cgoesche";
    repo = "0.2.2-pam-insults";
    rev = "2d13ef89640eb57b5e6a64eea080e57d9d936738";
    hash = "sha256-VbEJCO7lvTDKvGpTXQrpgeWEpZE4CMdwaRSuv5shsbw=";
  };

  nativeBuildInputs = [
    asciidoctor
    gzip
  ];

  buildInputs = [
    pam
    gettext
  ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "sudo " "" \
      --replace-fail "mandb" ""
  '';

  makeFlags = [
    "PAM_MODULES_DIR=$(out)/lib/security"
    "MAN_DATABASE=$(out)/share/man/man8"
  ];

  preInstall = ''
    mkdir -p $out/lib/security $out/share/man/man8
  '';

  meta = {
    description = "PAM module that will print an insult to stderr";
    homepage = "https://github.com/cgoesche/pam-insults";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.DieracDelta ];
  };
})
