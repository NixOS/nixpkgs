{ lib
, fetchFromGitHub
, stdenv
, buildMavenRepositoryFromLockFile
, jdk11
, makeWrapper
, maven
}:

let
  mavenRepository =
   buildMavenRepositoryFromLockFile { file = ./mvn2nix-lock.json; };
in stdenv.mkDerivation rec {
  pname = "xtreme-download-manager";
  version = "7.2.11";

  src = fetchFromGitHub {
    owner = "subhra74";
    repo = "xdm";
    rev = version;
    sha256 = "1p2mzaaig7fxk3gsk7r5shl1hijfz6bjlhmkqxgipywr1q1f67fb";
    name = "xdm";
  };

  sourceRoot = "xdm/app";

  buildInputs = [ jdk11 maven makeWrapper ];
  buildPhase = ''
    echo "Building with maven repository ${mavenRepository}"
    mvn package --offline -Dmaven.repo.local=${mavenRepository}
    runHook postBuild
  '';

  postBuild = ''
    mv target/xdman.jar target/${pname}-${version}.jar
  '';

  installPhase = ''
    # create the bin directory
    mkdir -p $out/bin

    # create a symbolic link for the lib directory
    ln -s ${mavenRepository} $out/lib

    # copy out the JAR
    # Maven already setup the classpath to use m2 repository layout
    # with the prefix of lib/
    cp target/${pname}-${version}.jar $out/

    # create a wrapper that will automatically set the classpath
    # this should be the paths from the dependency derivation
    makeWrapper ${jdk11}/bin/java $out/bin/${pname} \
          --add-flags "-jar $out/${pname}-${version}.jar"
  '';

  meta = with lib; {
    description = "Powerful download accelerator and video downloader";
    license = licenses.gpl2Plus;
    homepage = "http://subhra74.github.io/xdm";
    maintainers = with maintainers; [ shamilton ];
    platforms = platforms.linux;
  };
}
