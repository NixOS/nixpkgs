{
  lib,
  maven,
  fetchFromGitHub,
  makeWrapper,
  jre,
  jdk, # needed to suppress the following warnings during build:
  # [WARNING] msgfmt: Java compiler not found, try setting $JAVAC
  # [WARNING] msgfmt: compilation of Java class failed, please try --verbose or set $JAVAC
  gettext,
}:

maven.buildMavenPackage rec {
  pname = "jchempaint";
  version = "3.4-SNAPSHOT-2025-10-15"; # "3.4-SNAPSHOT" is the version given in the pom.xml

  src = fetchFromGitHub {
    owner = "JChemPaint";
    repo = "jchempaint";
    tag = "nightly";
    hash = "sha256-1wcJ1qP8yZg1qe4YkpCRGidHUXc1/1eUabR3NoM6kjc=";
  };

  mvnHash = "sha256-Wj1fAxL+QxVmqMkNb+/SEQjOp7p5/vVzPj5+fWPAhbE=";

  nativeBuildInputs = [
    makeWrapper
    gettext
    jdk
  ];

  mvnParameters = "-DskipTests";

  installPhase = ''
    runHook preInstall

    # Create output directories
    mkdir -p $out/bin $out/share/jchempaint

    cp app-jar/target/JChemPaint.jar $out/share/jchempaint/jchempaint.jar

    # Create wrapper script
    makeWrapper ${jre}/bin/java $out/bin/jchempaint \
      --add-flags "-jar $out/share/jchempaint/jchempaint.jar"

    runHook postInstall
  '';

  meta = {
    description = "Chemical 2D structure editor application/applet based on the Chemistry Development Kit";
    homepage = "https://jchempaint.github.io";
    changelog = "https://github.com/JChemPaint/jchempaint/releases/tag/nightly";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ ZZBaron ];
    mainProgram = "jchempaint";
  };
}
