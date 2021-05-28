{stdenv, fetchurl, ncurses, tcl, openssl, pam, kerberos
, openldap
}:

stdenv.mkDerivation rec {
  pname = "alpine";
  version = "2.23";

  src = fetchurl {
    url = "http://alpine.x10host.com/alpine/release/src/${pname}-${version}.tar.xz";
    sha256 = "0yqzm56lqgg8v66m09vqxjvpclli4pql5xj8zg7mynq0bhhn2fkr";
  };

  buildInputs = [
    ncurses tcl openssl pam kerberos openldap
  ];

  hardeningDisable = [ "format" ];

  configureFlags = [
    "--with-ssl-include-dir=${openssl.dev}/include/openssl"
    "--with-passfile=.pine-passfile"
    "--with-c-client-target=slx"
  ];

  meta = with stdenv.lib; {
    description = "Console mail reader";
    license = licenses.asl20;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    homepage = "http://alpine.x10host.com/";
  };
}
