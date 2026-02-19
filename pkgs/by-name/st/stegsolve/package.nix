{
  lib,
  stdenv,
  fetchFromGitHub,
  jdk,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "stegsolve";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "fee1-dead";
    repo = "Stegsolve";
    rev = finalAttrs.version;
    hash = "sha256-WiIZymeYnub0JilWGLXKhQKEoO1hce5DarbEjp+rTGQ==";
  };

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];
  buildInputs = [ jdk ];

  buildPhase = ''
    runHook preBuild

    mkdir -p out/
    javac -d out/ -sourcepath src/ -classpath out/ -encoding utf8 src/**/*.java

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/
    mv out $out/lib/stegsolve

    makeWrapper ${jdk}/bin/java $out/bin/stegsolve \
      --add-flags "-classpath $out/lib/stegsolve stegsolve.StegSolve"

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      type = "Application";
      name = "stegsolve";
      desktopName = "Stegsolve";
      comment = "A steganographic image analyzer, solver and data extractor for challanges";
      exec = "stegsolve";
      categories = [ "Graphics" ];
    })
  ];

  meta = {
    description = "Steganographic image analyzer, solver and data extractor for challanges";
    homepage = "https://www.wechall.net/forum/show/thread/527/Stegsolve_1.3/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      emilytrau
      fee1-dead
    ];
    platforms = lib.platforms.all;
    mainProgram = "stegsolve";
  };
})
