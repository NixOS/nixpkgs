{
  lib,
  stdenv,
  fetchzip,
  jdk,
  makeWrapper,
  installShellFiles,
}:

stdenv.mkDerivation rec {
  pname = "micronaut";
  version = "4.10.0";

  src = fetchzip {
    url = "https://github.com/micronaut-projects/micronaut-starter/releases/download/v${version}/micronaut-cli-${version}.zip";
    sha256 = "sha256-FYky14Lnl5B+zLgulFJdRdaDIQi+FhoUjce+LKYaMKE=";
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

  meta = with lib; {
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
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ moaxcp ];
    mainProgram = "mn";
  };
}
