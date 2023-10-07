{ lib, stdenv, fetchFromGitHub, openssl, lua, pcre2 }:

stdenv.mkDerivation (finalAttrs: {
  pname = "imapfilter";
  version = "2.8.1";

  src = fetchFromGitHub {
    owner = "lefcha";
    repo = "imapfilter";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-nHKZ3skRbDhKWocaw5mbaRnZC37FxFIVd08iFgrEA0s=";
  };
  makeFlags = [
    "SSLCAFILE=/etc/ssl/certs/ca-bundle.crt"
    "PREFIX=$(out)"
  ];

  buildInputs = [ openssl pcre2 lua ];

  meta = {
    homepage = "https://github.com/lefcha/imapfilter";
    description = "Mail filtering utility";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
})
