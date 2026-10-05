{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
  lua5_5,
  pcre2,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "imapfilter";
  version = "2.8.5";

  src = fetchFromGitHub {
    owner = "lefcha";
    repo = "imapfilter";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-EiYVkEyOrgX2WwWzFyQcuVheYZs1s3CGl01fMwtXBog=";
  };
  makeFlags = [
    "SSLCAFILE=/etc/ssl/certs/ca-bundle.crt"
    "PREFIX=$(out)"
  ];

  buildInputs = [
    openssl
    pcre2
    lua5_5
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgramArg = "-V";

  meta = {
    homepage = "https://github.com/lefcha/imapfilter";
    description = "Mail filtering utility";
    mainProgram = "imapfilter";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
})
