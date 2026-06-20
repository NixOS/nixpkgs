{
  lib,
  stdenv,
  fetchFromGitHub,
  gradle,
  jdk11,
  jdk21,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rhino";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "rhino";
    tag = "Rhino1_9_1_Release";
    hash = "sha256-zXHfaJWzNV5M8Tk8Ia33ECNIng4jvIk0p8OeB78RobY=";
  };

  nativeBuildInputs = [
    gradle
    jdk11
    jdk21
  ];

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  # rhino-kotlin requires java 11
  # https://github.com/mozilla/rhino/blob/Rhino1_9_1_Release/rhino-kotlin/build.gradle
  env = {
    JAVA_11_HOME = "${jdk11.home}";
    JAVA_21_HOME = "${jdk21.home}";
    JAVA_HOME = "${jdk21.home}";
  };

  gradleFlagsArray = [
    "-Porg.gradle.java.installations.fromEnv=JAVA_11_HOME,JAVA_21_HOME"
  ];

  # Newer releases now organize the code using Java modules.
  # https://github.com/mozilla/rhino/tree/Rhino1_9_1_Release#code-structure
  installPhase = ''
    set -u
    mkdir -p "$out/share/java"
    cp -v "rhino/build/libs/rhino-$version.jar" "$out/share/java/"
    components=("all" "engine" "kotlin" "tools" "xml")
    for component in "''${components[@]}"; do
      cp -v "rhino-$component/build/libs/rhino-$component-$version.jar" "$out/share/java/"
    done
  '';

  meta = {
    description = "Implementation of JavaScript written in Java";

    longDescription = ''
      Rhino is an open-source implementation of JavaScript written
      entirely in Java.  It is typically embedded into Java applications
      to provide scripting to end users.
    '';

    homepage = "https://rhino.github.io/";

    license = with lib.licenses; [
      mpl11 # or
      gpl2Plus
    ];

    maintainers = with lib.maintainers; [ zwang20 ];

    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
