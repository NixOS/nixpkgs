{stdenv, fetchurl, ncurses, tcl, openssl, pam, pkgconfig, gettext, kerberos
, openldap
}:

# NOTE: Please check if any changes here are applicable to ../realpine/ as well
let
  version = "2.00";
  baseName = "alpine";
in
stdenv.mkDerivation {
  name = "${baseName}-${version}";

  src = fetchurl {
    url = "ftp://ftp.cac.washington.edu/alpine/alpine-${version}.tar.bz2";
    sha256 = "19m2w21dqn55rhxbh5lr9qarc2fqa9wmpj204jx7a0zrb90bhpf8";
  };

  buildInputs = [
    ncurses tcl openssl pam kerberos openldap
  ];

  hardeningDisable = [ "format" "fortify" ];

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
    homepage = "https://www.washington.edu/alpine/";
  };
}
