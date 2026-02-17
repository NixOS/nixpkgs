{
  lib,
  stdenv,
  fetchurl,
  perlPackages,
  makeWrapper,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sslmate";
  version = "1.9.1";

  src = fetchurl {
    url = "https://packages.sslmate.com/other/sslmate-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-F5szGn1cbw7R3lHMocM7as1RS/uaBqKCsvOxA+rXDOc=";
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
})
