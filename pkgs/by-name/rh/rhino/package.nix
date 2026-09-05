{
  lib,
  stdenv,
  fetchFromGitHub,
  gradle_8,
}:
let
  # "Deprecated Gradle features were used in this build, making it incompatible with Gradle 9.0."
  gradle = gradle_8;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "rhino";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "rhino";
    tag = "Rhino1_8_0_Release";
    hash = "sha256-H8DbcRPMm4SKmGf40dXnjGeEbbj9COzdHgUIkcCimTM=";
  };

  nativeBuildInputs = [ gradle ];

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  installPhase = ''
    mkdir -p "$out/share/java"
    cp -v rhino-all/build/libs/rhino-all-*.jar "$out/share/java/js-$pkgver.jar"
    ln -s "js-$pkgver.jar" "$out/share/java/js.jar"
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
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
