{
  lib,
  stdenv,
  fetchFromGitHub,
  ant,
  jdk,
  stripJavaArchivesHook,
}:

stdenv.mkDerivation {
  pname = "hydra-ant-logger";
  version = "2010.2";

  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "hydra-ant-logger";
    rev = "dae3224f4ed42418d3492bdf5bee4f825819006f";
    hash = "sha256-5oQ/jZfz7izTcYR+N801HYh4lH2MF54PCMnmA4CpRwc=";
  };

  nativeBuildInputs = [
    ant
    jdk
    stripJavaArchivesHook
  ];

  buildPhase = ''
    runHook preBuild
    mkdir lib
    ant
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm644 *.jar -t $out/share/java
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/NixOS/hydra-ant-logger";
    platforms = lib.platforms.unix;
  };
}
