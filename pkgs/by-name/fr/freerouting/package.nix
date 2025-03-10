{
  lib,
  stdenv,
  fetchFromGitHub,
  makeBinaryWrapper,
  jdk,
  gradle,
  copyDesktopItems,
  jre,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "freerouting";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "freerouting";
    repo = "freerouting";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KedxMsDz5061ISbwHJpcTA0l68MKuTm2APOTdPyZeJQ=";
  };

  gradleBuildTask = "executableJar";

  nativeBuildInputs = [
    makeBinaryWrapper
    jdk
    gradle
    copyDesktopItems
  ];

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  __darwinAllowLocalNetworking = true;

  installPhase = ''
    mkdir -p $out/{bin,share/freerouting}
    cp build/libs/freerouting-executable.jar $out/share/freerouting

    makeWrapper ${lib.getExe jre} $out/bin/freerouting \
      --add-flags "-jar $out/share/freerouting/freerouting-executable.jar"
  '';

  meta = {
    description = "Advanced PCB auto-router";
    homepage = "https://www.freerouting.org";
    changelog = "https://github.com/freerouting/freerouting/releases/tag/v${finalAttrs.version}";
    longDescription = ''
      Freerouting is an advanced autorouter for all PCB programs that support
      the standard Specctra or Electra DSN interface. '';
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ srounce ];
    platforms = with lib.platforms; linux ++ darwin;
    mainProgram = "freerouting";
  };
})
