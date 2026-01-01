{
  lib,
  stdenv,
  fetchzip,
  makeWrapper,
  jre,
}:

stdenv.mkDerivation rec {
  pname = "jacoco";
<<<<<<< HEAD
  version = "0.8.14";
=======
  version = "0.8.12";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchzip {
    url = "https://search.maven.org/remotecontent?filepath=org/jacoco/jacoco/${version}/jacoco-${version}.zip";
    stripRoot = false;
<<<<<<< HEAD
    sha256 = "sha256-ysqPAxZK/mcnGiqqqTzfCOCyAcvMMvymFrSme6rFCJE=";
=======
    sha256 = "sha256-7bN68fcUycehJDJeBAyCloz8rb3SXgjwmC9zpob8YdI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  outputs = [
    "out"
    "doc"
  ];

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $doc/share/doc $out/bin

    cp -r doc $doc/share/doc/jacoco
    install -Dm444 lib/* -t $out/share/java

    makeWrapper ${jre}/bin/java $out/bin/jacoco \
      --add-flags "-jar $out/share/java/jacococli.jar"

    runHook postInstall
  '';

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Free code coverage library for Java";
    mainProgram = "jacoco";
    homepage = "https://www.jacoco.org/jacoco";
    changelog = "https://www.jacoco.org/jacoco/trunk/doc/changes.html";
<<<<<<< HEAD
    license = lib.licenses.epl20;
    platforms = lib.platforms.all;
=======
    license = licenses.epl20;
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
