{lib, stdenv, fetchurl, ncurses, tcl, openssl, pam, libkrb5
, openldap
}:

stdenv.mkDerivation rec {
  pname = "alpine";
  version = "2.25";

  src = fetchurl {
    url = "http://alpine.x10host.com/alpine/release/src/${pname}-${version}.tar.xz";
    sha256 = "0xppxhcbafq9qa1rns5zl0n238gai08xhvcf2as0nx7nh84ib2k5";
  };

  buildInputs = [
    ncurses tcl openssl pam libkrb5 openldap
  ];

  hardeningDisable = [ "format" ];

  configureFlags = [
    "--with-ssl-include-dir=${openssl.dev}/include/openssl"
    "--with-passfile=.pine-passfile"
    "--with-c-client-target=slx"
  ];

  meta = with lib; {
    description = "Console mail reader";
    license = licenses.asl20;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    homepage = "http://alpine.x10host.com/";
  };
}
