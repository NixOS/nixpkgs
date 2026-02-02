{
  lib,
  stdenv,
  fetchzip,
  jdk,
  makeWrapper,
  installShellFiles,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "micronaut";
  version = "4.10.7";

  src = fetchzip {
    url = "https://github.com/micronaut-projects/micronaut-starter/releases/download/v${finalAttrs.version}/micronaut-cli-${finalAttrs.version}.zip";
    hash = "sha256-2iYCcqZqpQ5v6VGtGiPYx+97VDuC61F8Vl4MLVh+vc0=";
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
      --prefix JAVA_HOME : ${jdk}
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
