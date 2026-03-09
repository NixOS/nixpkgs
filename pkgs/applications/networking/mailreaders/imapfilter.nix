{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
  lua,
  pcre2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "imapfilter";
  version = "2.8.4";

  src = fetchFromGitHub {
    owner = "lefcha";
    repo = "imapfilter";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-ZuyRnN4khdE+z54Ag0b/coiGdUzn/9yT49GpDI4kr8Q=";
  };
  makeFlags = [
    "SSLCAFILE=/etc/ssl/certs/ca-bundle.crt"
    "PREFIX=$(out)"
  ];

  buildInputs = [
    openssl
    pcre2
    lua
  ];

  meta = {
    homepage = "https://github.com/lefcha/imapfilter";
    description = "Mail filtering utility";
    mainProgram = "imapfilter";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
})
