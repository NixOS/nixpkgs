{ lib, stdenv, fetchFromGitHub, openssl, lua, pcre2 }:

stdenv.mkDerivation rec {
  pname = "imapfilter";
  version = "2.7.6";

  src = fetchFromGitHub {
    owner = "lefcha";
    repo = "imapfilter";
    rev = "v${version}";
    sha256 = "sha256-7B3ebY2QAk+64NycptoMmAo7GxUFOo3a7CH7txV/KTY=";
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
}
