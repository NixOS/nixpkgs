{ stdenv, fetchurl, postgresql, wxGTK, libxml2, libxslt, openssl }:

stdenv.mkDerivation rec {
  name = "pgadmin3-1.10.0";

  src = fetchurl {
    url = "http://ftp3.de.postgresql.org/pub/Mirrors/ftp.postgresql.org/pgadmin3/release/v1.10.0/src/pgadmin3-1.10.0.tar.gz";
    sha256 = "1ndi951da3jw5800fjdgkbvl8n6k71x7x16ghihi1l88bilf2a16";
  };

  buildInputs = [ postgresql wxGTK libxml2 libxslt openssl ];

  meta = { 
    description = "PostgreSQL administration GUI tool";
    homepage = http://www.pgadmin.org;
    license = "GPL2";
  };
}
