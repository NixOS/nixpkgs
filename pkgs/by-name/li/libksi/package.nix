{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  openssl,
  curl,
}:

stdenv.mkDerivation rec {
  pname = "libksi";
  version = "3.21.3087";

  src = fetchFromGitHub {
    owner = "Guardtime";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-zEWxJpv0MeGUq/xkM26tDoauFyw53enGyWVhlX0jlYI=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [
    openssl
    curl
  ];

  configureFlags = [
    "--with-openssl=${openssl.dev}"
    "--with-cafile=/etc/ssl/certs/ca-certificates.crt"
  ];

  meta = with lib; {
    homepage = "https://github.com/GuardTime/libksi";
    description = "Keyless Signature Infrastructure API library";
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
