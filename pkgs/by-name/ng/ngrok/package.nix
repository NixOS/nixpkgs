{
  lib,
  stdenv,
  fetchurl,
  testers,
}:

let
  version = "3.39.10";
  sources = {
    i686-linux = fetchurl {
      url = "https://bin.ngrok.com/a/3fcY7AHuPyf/ngrok-v3-3.39.10-linux-386";
      hash = "sha256-D7YyL4y/mQM32Ibb705phAAPd3+ePdzobpdaijNGmOw=";
    };
    x86_64-linux = fetchurl {
      url = "https://bin.ngrok.com/a/jhBAuesrzKn/ngrok-v3-3.39.10-linux-amd64";
      hash = "sha256-tHXDG0Ce00Jgkb3ni2D64n7e5HDCMgyzBldDwVm5sns=";
    };
    aarch64-linux = fetchurl {
      url = "https://bin.ngrok.com/a/55PuHLixvyF/ngrok-v3-3.39.10-linux-arm64";
      hash = "sha256-otHU2Nrrza4FQVO+26lvD6vHhZ8En20WbvJSbvZiCr4=";
    };
    aarch64-darwin = fetchurl {
      url = "https://bin.ngrok.com/a/aQGG8qqiJvo/ngrok-v3-3.39.10-darwin-arm64";
      hash = "sha256-0zWkegTd5yaJei51MYfp9I+/QGFsSL4yZpVMe5F1oJ4=";
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ngrok";
  inherit version;

  src = sources.${stdenv.hostPlatform.system};

  sourceRoot = ".";

  unpackPhase = ''
    runHook preUnpack
    cp $src ngrok
    runHook postUnpack
  '';

  buildPhase = ''
    runHook preBuild
    chmod a+x ngrok
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -D ngrok $out/bin/ngrok
    runHook postInstall
  '';

  passthru = {
    platforms = builtins.attrNames sources;
    inherit sources;
    updateScript = ./update.sh;
    tests.version = testers.testVersion { package = finalAttrs.finalPackage; };
  };

  # Stripping causes SEGFAULT on darwin
  dontStrip = stdenv.hostPlatform.isDarwin;

  meta = {
    description = "Allows you to expose a web server running on your local machine to the internet";
    homepage = "https://ngrok.com/";
    downloadPage = "https://ngrok.com/download";
    changelog = "https://ngrok.com/docs/agent/changelog/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = builtins.attrNames sources;
    maintainers = with lib.maintainers; [
      bobvanderlinden
      brodes
    ];
    mainProgram = "ngrok";
  };
})
