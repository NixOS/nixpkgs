{ lib, stdenv, fetchzip, jdk11, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "apache-directory-server";
  version = "2.0.0.AM26";

  src = fetchzip {
    url = "mirror://apache/directory/apacheds/dist/${version}/apacheds-${version}.zip";
    sha256 = "sha256-36kDvfSy5rt/3+nivEFTepnIKf6sX0NTgPRm28M+1v4=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin $out/share/apacheds
    install -D $src/lib/*.jar $out/share/apacheds
    classpath=$(jars=($out/share/apacheds/*.jar); IFS=:; echo "''${jars[*]}")
    makeWrapper ${jdk11}/bin/java $out/bin/apache-directory-server \
      --add-flags "-classpath $classpath org.apache.directory.server.UberjarMain"
  '';

  meta = with lib; {
    description = "Extensible and embeddable directory server";
    mainProgram = "apache-directory-server";
    homepage = "https://directory.apache.org/apacheds/";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = [ maintainers.ners ];
  };
}
