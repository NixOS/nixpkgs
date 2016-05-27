{stdenv, fetchurl, ncurses, tcl, openssl, pam, pkgconfig, gettext, kerberos
, openldap
}:
let
  s = 
  rec {
    version = "2.03";
    url = "mirror://sourceforge/re-alpine/re-alpine-${version}.tar.bz2";
    sha256 = "11xspzbk9cwmklmcw6rxsan7j71ysd4m9c7qldlc59ck595k5nbh";
    baseName = "re-alpine";
    name = "${baseName}-${version}";
  };
  buildInputs = [
    ncurses tcl openssl pam kerberos openldap
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs;
  src = fetchurl {
    inherit (s) url sha256;
  };
  configureFlags = [
    "--with-ssl-include-dir=${openssl.dev}/include/openssl"
    "--with-tcl-lib=${tcl.libPrefix}"
    ];
  preConfigure = ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -lgcc_s"
  '';
  meta = {
    inherit (s) version;
    description = ''Console mail reader'';
    license = stdenv.lib.licenses.asl20;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    homepage = "http://re-alpine.sf.net/";
    downloadPage = "http://sourceforge.net/projects/re-alpine/files/";
  };
}
