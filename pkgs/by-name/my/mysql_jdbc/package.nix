{
  lib,
  stdenv,
  fetchurl,
  ant,
  unzip,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "mysql-connector-java";
  version = "9.4.0";

  src = fetchurl {
    url = "https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-j-${version}.zip";
    hash = "sha256-Ze/HzVelG3p5tFnu0lvP0gKWvGr3yGWGBjlVEBZorJ4=";
  };

  installPhase = ''
    mkdir -p $out/share/java
    cp mysql-connector-j-*.jar $out/share/java/mysql-connector-j.jar
  '';

  nativeBuildInputs = [ unzip ];

  buildInputs = [ ant ];

  passthru.updateScript = gitUpdater {
    url = "https://github.com/mysql/mysql-connector-j.git";
  };

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "MySQL Connector/J";
    homepage = "https://dev.mysql.com/doc/connector-j/en/";
    changelog = "https://dev.mysql.com/doc/relnotes/connector-j/en/";
    maintainers = [ ];
<<<<<<< HEAD
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl2Only;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
=======
    platforms = platforms.unix;
    license = licenses.gpl2Only;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
