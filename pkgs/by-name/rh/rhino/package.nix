{
  fetchFromGitHub,
  lib,
  stdenv,
  gradle,
  jdk21,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "rhino";
  version = "1.7.15";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "rhino";
    # Replace dots in the version with underscores
    rev = "Rhino${builtins.replaceStrings [ "." ] [ "_" ] version}_Release";
    hash = "sha256-L0+ur7wKFSpHT5f6HB4Rj/aoGvRORZRLi+WwVCkVkjE=";
  };

  mitmCache = gradle.fetchDeps {
    inherit pname;
    data = ./deps.json;
  };

  __darwinAllowLocalNetworking = true;

  gradleBuildTask = "assembleDist";

  # A number of tests fail
  # TODO: Enable this once tests pass upstream
  doCheck = false;

  # FIXME(tomodachi94): Still necessary?
  hardeningDisable = [
    "fortify"
    "format"
  ];

  nativeBuildInputs = [
    gradle
    makeWrapper
  ];
  buildInputs = [ jdk21 ];

  # FIXME: Install javadoc as well.
  installPhase = ''
    mkdir -p "$out/share/java"
    cp -v buildGradle/libs/source-${version}.jar buildGradle/libs/rhino-*.jar "$out/share/java"
    # FIXME: Unsure if this should be the desired behavior
    ln -s "$out/share/java/source-${version}.jar" "$out/share/java/rhino-${version}.jar"

    makeWrapper "${jdk21}/bin/java" "$out/bin/rhino" \
      --add-flags "-jar $out/share/java/rhino-${version}.jar"
  '';

  passthru = {
    updateScript = ./update.sh;
  };

  meta = with lib; {
    description = "Implementation of JavaScript written in Java";
    longDescription = ''
      Rhino is an open-source implementation of JavaScript written
      entirely in Java.  It is typically embedded into Java applications
      to provide scripting to end users.
    '';
    homepage = "http://www.mozilla.org/rhino/";
    license = with licenses; [
      mpl11 # or
      gpl2Plus
    ];
    platforms = jdk21.meta.platforms;
    maintainers = with maintainers; [ tomodachi94 ];
  };
}
