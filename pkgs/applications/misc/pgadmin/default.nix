args:
args.stdenv.mkDerivation {
  name = "pgadmin3-1.8.1";

  src = args.fetchurl {
    name = "pgadmin3-v1.8.1.tar.gz";
    url = "http://ftp3.de.postgresql.org/pub/Mirrors/ftp.postgresql.org//pgadmin3/release/v1.8.1/src/pgadmin3-1.8.1.tar.gz";
    sha256 = "1vnpbgb2ksvcgbzab4jjspwvs5cvam53azinfavjad4kpjczdywb";
  };

  buildInputs =(with args; [postgresql wxGTK libxml2 libxslt openssl]);

  meta = { 
      description = "postgresql admin gui tool";
      homepage = http://www.pgadmin.org/download/;
      license = "GPL2";
    };
}
