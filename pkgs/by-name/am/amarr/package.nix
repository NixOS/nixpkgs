{
  stdenv,
  fetchFromGitHub,
  gradle_7,
  makeWrapper,
  lib,
  jre,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "amarr";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "vexdev";
    repo = "amarr";
    rev = "v${finalAttrs.version}";
    hash = "sha256-rJFkIfrOS64KjkHyULuGbO/2eGyZgMR4EcV2pyAtoio=";
  };

  nativeBuildInputs = [
    gradle_7
    makeWrapper
  ];

  mitmCache = gradle_7.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  gradleFlags = [ "-Dfile.encoding=utf-8" ];

  gradleBuildTask = "installDist";

  doCheck = true;

  installPhase = ''
    runHook preInstall

    install -D -m 0755 app/build/install/app/bin/app $out/bin/amarr
    mkdir $out/lib
    install -m 0644 app/build/install/app/lib/* $out/lib/

    runHook postInstall
  '';

  postInstall = ''
    wrapProgram $out/bin/amarr \
      --set JAVA_HOME ${jre} \
  '';

  meta = {
    description = "aMule Torrent connector for Servarr";
    homepage = "https://github.com/vexdev/amarr";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      aciceri
    ];
    mainProgram = "amarr";
    platforms = lib.platforms.linux;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
  };
})
