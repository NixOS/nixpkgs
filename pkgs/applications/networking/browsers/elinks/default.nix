{ stdenv, fetchurl, python, perl, ncurses, x11, bzip2, zlib, openssl
, spidermonkey, gpm
, enableGuile ? true, guile ? null }:

assert enableGuile -> guile != null;

stdenv.mkDerivation rec {
  name = "elinks-0.12pre5";

  src = fetchurl {
    url = http://elinks.or.cz/download/elinks-0.12pre5.tar.bz2;
    sha256 = "1li4vlbq8wvnigxlkzb15490y90jg6y9yzzrqpqcz2h965w5869d";
  };

  patches = [ ./gc-init.patch ];

  buildInputs = [ python perl ncurses x11 bzip2 zlib openssl spidermonkey gpm ]
    ++ stdenv.lib.optional enableGuile guile;

  configureFlags =
    ''
      --enable-finger --enable-html-highlight
      --with-perl --with-python --enable-gopher --enable-cgi --enable-bittorrent
      --enable-nntp --with-openssl=${openssl}
    '' + stdenv.lib.optionalString enableGuile " --with-guile";

  crossAttrs = {
    propagatedBuildInputs = [ ncurses.crossDrv zlib.crossDrv openssl.crossDrv ];
    configureFlags = ''
      --enable-finger --enable-html-highlight
      --enable-gopher --enable-cgi --enable-bittorrent --enable-nntp
      --with-openssl=${openssl.crossDrv}
      --with-bzip2=${bzip2.crossDrv}
    '';
  };

  meta = {
    description = "Full-featured text-mode web browser";
    homepage = http://elinks.or.cz;
  };
}
