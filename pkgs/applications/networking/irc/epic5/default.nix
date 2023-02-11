{ lib, stdenv, fetchurl, openssl, ncurses, libiconv, tcl, coreutils, fetchpatch, libxcrypt }:

stdenv.mkDerivation rec {
  pname = "epic5";
  version = "2.0.1";

  src = fetchurl {
    url = "http://ftp.epicsol.org/pub/epic/EPIC5-PRODUCTION/${pname}-${version}.tar.xz";
    sha256 = "1ap73d5f4vccxjaaq249zh981z85106vvqmxfm4plvy76b40y9jm";
  };

  # Darwin needs libiconv, tcl; while Linux build don't
  buildInputs = [ openssl ncurses libxcrypt ]
    ++ lib.optionals stdenv.isDarwin [ libiconv tcl ];

  patches = [
    (fetchpatch {
      url = "https://sources.debian.net/data/main/e/epic5/2.0.1-1/debian/patches/openssl-1.1.patch";
      sha256 = "03bpsyv1sr5icajs2qkdvv8nnn6rz6yvvj7pgiq8gz9sbp6siyfv";
    })
  ];

  configureFlags = [ "--disable-debug" "--with-ipv6" ];

  postConfigure = ''
    substituteInPlace bsdinstall \
      --replace /bin/cp ${coreutils}/bin/cp \
      --replace /bin/rm ${coreutils}/bin/rm \
      --replace /bin/chmod ${coreutils}/bin/chmod \
  '';

  meta = with lib; {
    homepage = "http://epicsol.org";
    description = "A IRC client that offers a great ircII interface";
    license = licenses.bsd3;
    maintainers = [];
  };
}



