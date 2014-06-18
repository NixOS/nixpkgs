{ stdenv, fetchurl, postgresql, wxGTK, libxml2, libxslt, openssl }:

stdenv.mkDerivation rec {
  name = "pgadmin3-${version}";
  version = "1.18.1";

  src = fetchurl {
    url = "http://ftp.postgresql.org/pub/pgadmin3/release/v${version}/src/pgadmin3-${version}.tar.gz";
    sha256 = "1h6bqslw53q44vy7z1q7wmxkgqdzxacfs8pfm2fxm8vcd8lkxb17";
  };

  buildInputs = [ postgresql wxGTK libxml2 libxslt openssl ];

  preConfigure = ''
    substituteInPlace pgadmin/ver_svn.sh --replace "bin/bash" "$shell"
  '';

  meta = with stdenv.lib; { 
    description = "PostgreSQL administration GUI tool";
    homepage = http://www.pgadmin.org;
    license = licenses.gpl2;
    maintainers = with maintainers; [ iElectric wmertens ];
    platforms = platforms.unix;
  };
}
