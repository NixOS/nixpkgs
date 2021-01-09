{ stdenv, fetchFromGitHub, openssl, lua, pcre2 }:

stdenv.mkDerivation rec {
  pname = "imapfilter";
  version = "2.7.5";

  src = fetchFromGitHub {
    owner = "lefcha";
    repo = "imapfilter";
    rev = "v${version}";
    sha256 = "nbVwbPkNbJz4GHhvOp+QVgiBqKA/HR34p4x3NXJB7ig=";
  };
  makeFlags = [
    "SSLCAFILE=/etc/ssl/certs/ca-bundle.crt"
    "PREFIX=$(out)"
  ];

  buildInputs = [ openssl pcre2 lua ];

  meta = {
    homepage = "https://github.com/lefcha/imapfilter";
    description = "Mail filtering utility";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ doronbehar ];
  };
}
