{ stdenv, fetchurl, postgresql, wxGTK, libxml2, libxslt, openssl, zlib }:

stdenv.mkDerivation rec {
  name = "pgadmin3-${version}";
  version = "1.22.1";

  src = fetchurl {
    url = "http://ftp.postgresql.org/pub/pgadmin3/release/v${version}/src/pgadmin3-${version}.tar.gz";
    sha256 = "0gkqpj8cg6jd6yhssrij1cbh960rg9fkjbdzcpryi6axwv0ag7ki";
  };

  enableParallelBuilding = true;

  buildInputs = [ postgresql wxGTK openssl zlib ];

  preConfigure = ''
    substituteInPlace pgadmin/ver_svn.sh --replace "bin/bash" "$shell"
  '';

  configureFlags = [
    "--with-libxml2=${libxml2}"
    "--with-libxslt=${libxslt}"
  ];

  meta = with stdenv.lib; { 
    description = "PostgreSQL administration GUI tool";
    homepage = http://www.pgadmin.org;
    license = licenses.gpl2;
    maintainers = with maintainers; [ iElectric wmertens ];
    platforms = platforms.unix;
  };
}
