{
  lib,
  stdenv,
  fetchurl,
  testers,
}:

let
  version = "3.39.13";
  sources = {
    i686-linux = fetchurl {
      url = "https://bin.ngrok.com/a/bXbZMkw2tQW/ngrok-v3-3.39.13-linux-386";
      hash = "sha256-Wu0jSajA4ruVGDMFRznKb+R+agfDutVBrK0/mMBFMxs=";
    };
    x86_64-linux = fetchurl {
      url = "https://bin.ngrok.com/a/2u8ZAPuZnnL/ngrok-v3-3.39.13-linux-amd64";
      hash = "sha256-Q5k4S/TWpa1lE2dwqTFTbbnpeRH1JobjQZ3ENKdN918=";
    };
    aarch64-linux = fetchurl {
      url = "https://bin.ngrok.com/a/gNfeve1VDdJ/ngrok-v3-3.39.13-linux-arm64";
      hash = "sha256-uVEr2+z8FJUQ9fC80Y16BtAz1+KjcfdrN81VtE8D5bU=";
    };
    aarch64-darwin = fetchurl {
      url = "https://bin.ngrok.com/a/aRfC2Kft1Jc/ngrok-v3-3.39.13-darwin-arm64";
      hash = "sha256-aGwy8dav+GTrLyId7clzAtexz4Y8a3HlfrgBDWUoQyE=";
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
