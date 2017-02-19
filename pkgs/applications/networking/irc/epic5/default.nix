{ stdenv, fetchurl, openssl, ncurses, libiconv, tcl, coreutils }:

stdenv.mkDerivation rec {
  name = "epic5-${version}";
  version = "2.0.1";

  src = fetchurl {
    url = "http://ftp.epicsol.org/pub/epic/EPIC5-PRODUCTION/${name}.tar.xz";
    sha256 = "1ap73d5f4vccxjaaq249zh981z85106vvqmxfm4plvy76b40y9jm";
  };

  # Darwin needs libiconv, tcl; while Linux build don't
  buildInputs = [ openssl ncurses ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ libiconv tcl ];

  configureFlags = [ "--disable-debug" "--with-ipv6" ];

  postConfigure = ''
    substituteInPlace bsdinstall \
      --replace /bin/cp ${coreutils}/bin/cp \
      --replace /bin/rm ${coreutils}/bin/rm \
      --replace /bin/chmod ${coreutils}/bin/chmod \
  '';

  meta = with stdenv.lib; {
    homepage = "http://epicsol.org";
    description = "A IRC client that offers a great ircII interface";
    license = licenses.bsd3;
    maintainers = [ maintainers.ndowens ];
  };
}



