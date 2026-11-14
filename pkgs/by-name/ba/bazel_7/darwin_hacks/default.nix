{
  stdenv,
  buildJdk,
  runJdk,
  version,
  writeScript,
}:
let
  fakeBazelModules = stdenv.mkDerivation {
    pname = "fakeBazelModules";
    inherit version;
    dontUnpack = true;
    buildPhase = "
      # Java file name needs to match class name so we need to copy
      cp ${./BlazeModule.java} ./BlazeModule.java
      cp ${./SystemSuspensionModule.java} ./SystemSuspensionModule.java
      cp ${./SleepPreventionModule.java} ./SleepPreventionModule.java

      # compile all sources
      ${buildJdk}/bin/javac -d . BlazeModule.java SystemSuspensionModule.java SleepPreventionModule.java

      # don't package BlazeModule.class as we want to use real base class, but a stub compatible version was needed to make
      # fake modules compile
      ${buildJdk}/bin/jar cf output.jar ./com/google/devtools/build/lib/platform/{SystemSuspension,SleepPrevention}Module.class
    ";
    installPhase = ''
      runHook preInstall

      mkdir -p $out/
      install -Dm755 output.jar $out/output.jar

      runHook postInstall
    '';

  };
  # bin/java wrapper that injects fake modules into classpath
  jvmInterceptSh = writeScript "java" ''
    #!/usr/bin/env bash

    # replaces
    # .. -jar foo.jar ..
    # with
    # .. -cp ..overrides..:foo.jar MainClass ..
    # to inject fake modules classes into Bazel

    for (( i=2; i <= "$#"; i++ )); do
      if [[ "''${!i}" == "-jar" ]]; then
        prev=$(( i - 1 ))
        jar=$(( i + 1 ))
        MAIN_CLASS=$(unzip -qc "''${!jar}" META-INF/MANIFEST.MF | grep "^Main-Class: " | cut -d " " -f 2- | tr -d "\r")
        next=$(( jar + 1 ))
        exec "${runJdk}/bin/java" "''${@:1:prev}" -cp "${fakeBazelModules}/output.jar:''${!jar}" "$MAIN_CLASS" "''${@:next}"
      fi
    done

    echo "Failed to find -jar argument in: $@" >&2
    exit 1
  '';
in
{
  jvmIntercept = stdenv.mkDerivation {
    pname = "jvmIntercept";
    inherit version;
    dontUnpack = true;
    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      install -Dm755 ${jvmInterceptSh} $out/bin/java

      runHook postInstall
    '';
  };

}
