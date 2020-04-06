{stdenv, fetchurl, ncurses, tcl, openssl, pam, kerberos
, openldap
}:

stdenv.mkDerivation rec {
  pname = "alpine";
  version = "2.21";

  src = fetchurl {
    url = "http://alpine.x10host.com/alpine/release/src/${pname}-${version}.tar.xz";
    sha256 = "0f3llxrmaxw7w9w6aixh752md3cdc91mwfmbarkm8s413f4bcc30";
  };

  buildInputs = [
    ncurses tcl openssl pam kerberos openldap
  ];

  hardeningDisable = [ "format" ];

  configureFlags = [
    "--with-ssl-include-dir=${openssl.dev}/include/openssl"
    "--with-passfile=.pine-passfile"
  ];

  meta = with stdenv.lib; {
    description = "Console mail reader";
    license = licenses.asl20;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    homepage = "http://alpine.x10host.com/";
  };
}
