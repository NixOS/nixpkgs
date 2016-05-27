{stdenv, fetchurl, ncurses, tcl, openssl, pam, pkgconfig, gettext, kerberos
, openldap
}:
let
  s = 
  rec {
    version = "2.00";
    url = "ftp://ftp.cac.washington.edu/alpine/alpine-${version}.tar.bz2";
    sha256 = "19m2w21dqn55rhxbh5lr9qarc2fqa9wmpj204jx7a0zrb90bhpf8";
    baseName = "alpine";
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
    homepage = "https://www.washington.edu/alpine/";
  };
}
