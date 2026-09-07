{
  lib,
  stdenv,
  fetchzip,
  jdk25,
  makeWrapper,
  installShellFiles,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "micronaut";
  version = "5.1.2";

  src = fetchzip {
    url = "https://github.com/micronaut-projects/micronaut-starter/releases/download/v${finalAttrs.version}/micronaut-cli-${finalAttrs.version}.zip";
    hash = "sha256-GWP+4RNM5ya7ZZ36qttK4VCzmd7Utt9MOfxxS8X5Adc=";
  };

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  installPhase = ''
    runHook preInstall
    rm bin/mn.bat
    cp -r . $out
    wrapProgram $out/bin/mn \
      --prefix JAVA_HOME : ${jdk25}
    installShellCompletion --bash --name mn.bash bin/mn_completion
    runHook postInstall
  '';

  meta = {
    description = "Modern, JVM-based, full-stack framework for building microservice applications";
    longDescription = ''
      Micronaut is a modern, JVM-based, full stack microservices framework
      designed for building modular, easily testable microservice applications.
      Reflection-based IoC frameworks load and cache reflection data for
      every single field, method, and constructor in your code, whereas with
      Micronaut, your application startup time and memory consumption are
      not bound to the size of your codebase.
    '';
    homepage = "https://micronaut.io/";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ moaxcp ];
    mainProgram = "mn";
  };
})
