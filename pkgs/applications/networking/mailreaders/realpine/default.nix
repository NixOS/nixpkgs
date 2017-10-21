{stdenv, fetchurl, ncurses, tcl, openssl, pam, pkgconfig, gettext, kerberos
, openldap
}:
# NOTE: Please check if any changes here are applicable to ../alpine/ as well
let
  baseName = "re-alpine";
  version = "2.03";
in
stdenv.mkDerivation {
  name = "${baseName}-${version}";
  inherit version;

  src = fetchurl {
    url = "mirror://sourceforge/re-alpine/re-alpine-${version}.tar.bz2";
    sha256 = "11xspzbk9cwmklmcw6rxsan7j71ysd4m9c7qldlc59ck595k5nbh";
  };

  buildInputs = [
    ncurses tcl openssl pam kerberos openldap
  ];

  hardeningDisable = [ "format" ];

  configureFlags = [
    "--with-ssl-include-dir=${openssl.dev}/include/openssl"
    "--with-tcl-lib=${tcl.libPrefix}"
    "--with-passfile=.pine-passfile"
  ];

  preConfigure = ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -lgcc_s"
  '';

  meta = {
    description = "Console mail reader";
    license = stdenv.lib.licenses.asl20;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    homepage = http://re-alpine.sf.net/;
    downloadPage = "http://sourceforge.net/projects/re-alpine/files/";
  };
}
