{
  lib,
  stdenv,
  fetchFromGitHub,
  ant,
  jdk,
  jre,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jython";

  version = "2.7.4";

  src = fetchFromGitHub {
    owner = "jython";
    repo = "jython";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Ef5pabXjQlVLn+8RE5rSwmxbjr04okBN4jRDMWBMOJo=";
  };

  nativeBuildInputs = [
    ant
    jdk
    makeWrapper
  ];

  buildPhase = ''
    runHook preBuild

    ant jar-standalone

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 dist/jython-standalone.jar $out/share/jython.jar

    makeWrapper ${lib.getExe jre} $out/bin/jython \
      --add-flags "-jar $out/share/jython.jar"

    runHook postInstall
  '';

  meta = {
    description = "Python interpreter written in Java";
    mainProgram = "jython";
    homepage = "https://jython.org/";
    license = lib.licenses.psfl;
    platforms = jre.meta.platforms;
  };
})
