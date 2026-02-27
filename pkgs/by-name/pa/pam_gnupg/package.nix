{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pam,
  gnupg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pam_gnupg";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "cruegge";
    repo = "pam-gnupg";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-6I9a841qohA42lhOgZf/hharnjkthuB8lRptPDxUgMI=";
  };

  configureFlags = [
    "--with-moduledir=${placeholder "out"}/lib/security"
  ];

  buildInputs = [
    pam
    gnupg
  ];

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    description = "Unlock GnuPG keys on login";
    longDescription = ''
      A PAM module that hands over your login password to gpg-agent. This can
      be useful if you are using a GnuPG-based password manager like pass.
    '';
    homepage = "https://github.com/cruegge/pam-gnupg";
    license = lib.licenses.gpl3;
    maintainers = [ ];
  };
})
