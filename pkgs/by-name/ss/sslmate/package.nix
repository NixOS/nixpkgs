{
  lib,
  stdenv,
  fetchurl,
  perlPackages,
  makeWrapper,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "sslmate";
  version = "1.10.0";

  src = fetchurl {
    url = "https://packages.sslmate.com/other/${pname}-${version}.tar.gz";
    sha256 = "sha256-yjeK/CjFSjjymriVb41AWy0SSJ5mwPp6T+asyHaeX5E=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ perlPackages.perl ];

  postInstall = ''
    wrapProgram $out/bin/sslmate --prefix PERL5LIB : \
      "${
        with perlPackages;
        makePerlPath [
          URI
          JSONPP
          TermReadKey
        ]
      }" \
      --prefix PATH : "${openssl.bin}/bin"
  '';

  meta = {
    homepage = "https://sslmate.com";
    maintainers = [ ];
    description = "Easy to buy, deploy, and manage your SSL certs";
    mainProgram = "sslmate";
    platforms = lib.platforms.unix;
    license = lib.licenses.mit; # X11
  };
}
