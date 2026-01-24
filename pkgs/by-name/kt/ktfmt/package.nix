{
  lib,
  stdenv,
  fetchFromGitHub,
  jre_headless,
  makeWrapper,
  gradle,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ktfmt";
  version = "0.61";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "ktfmt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WY3d25c8VLsgeNBV/lSlOL+C3XtM9lfRYqMz3Z0mT3s=";
  };

  patches = [ ./remove-idea-plugin.patch ];

  nativeBuildInputs = [
    gradle
    makeWrapper
  ];

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };
  __darwinAllowLocalNetworking = true; # this is required for using mitm-cache on Darwin

  gradleFlags = [ "-Dfile.encoding=utf-8" ];

  doCheck = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 core/build/libs/ktfmt-*-with-dependencies.jar $out/share/ktfmt/ktfmt.jar

    makeWrapper ${jre_headless}/bin/java $out/bin/ktfmt \
      --add-flags "-jar $out/share/ktfmt/ktfmt.jar"

    runHook postInstall
  '';

  meta = {
    description = "Program that reformats Kotlin source code to comply with the common community standard for Kotlin code conventions";
    homepage = "https://github.com/facebook/ktfmt";
    license = lib.licenses.asl20;
    mainProgram = "ktfmt";
    maintainers = with lib.maintainers; [ ghostbuster91 ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # mitm cache
    ];
    inherit (jre_headless.meta) platforms;
  };
})
