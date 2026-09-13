{
  lib,
  stdenv,
  fetchurl,
  testers,
}:

let
  version = "3.39.11";
  sources = {
    i686-linux = fetchurl {
      url = "https://bin.ngrok.com/a/giK691VJU4P/ngrok-v3-3.39.11-linux-386";
      hash = "sha256-s/oFlg/S6cAfokexVKWHUXtcmycnT1uMVzIRvYrdr0g=";
    };
    x86_64-linux = fetchurl {
      url = "https://bin.ngrok.com/a/58nxNCjvFS5/ngrok-v3-3.39.9-linux-amd64";
      hash = "sha256-0mw/peLKVlzudwAekqGUDr7Lzwz54vitQxmkKaqhvz8=";
    };
    aarch64-linux = fetchurl {
      url = "https://bin.ngrok.com/a/hqSwTx7kQJX/ngrok-v3-3.39.11-linux-arm64";
      hash = "sha256-NcMf7jdsZ0Txcw2klPCsFmyH5JdBhns9wreddlwT9X0=";
    };
    aarch64-darwin = fetchurl {
      url = "https://bin.ngrok.com/a/2XxCp7ATrBc/ngrok-v3-3.39.11-darwin-arm64";
      hash = "sha256-6jpXBgS9Fh0AunNYr0rS1rCsTIQhwX/AEGtSfe/7yI8=";
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
