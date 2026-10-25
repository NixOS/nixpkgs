{
  lib,
  stdenv,
  fetchurl,
  testers,
}:

let
  version = "3.39.12";
  sources = {
    i686-linux = fetchurl {
      url = "https://bin.ngrok.com/a/jxA7skg74U9/ngrok-v3-3.39.12-linux-386";
      hash = "sha256-jFjsby9mvdL/oJf/TOnXbHG3bn1G5Eas1ZPOEfsmeYs=";
    };
    x86_64-linux = fetchurl {
      url = "https://bin.ngrok.com/a/na2RHstMKx3/ngrok-v3-3.39.12-linux-amd64";
      hash = "sha256-DRTI9rWAwtL0Lt11rRDAFGzKV2XT5G8wCFvvH8j7Nrk=";
    };
    aarch64-linux = fetchurl {
      url = "https://bin.ngrok.com/a/2b3dsZdSECc/ngrok-v3-3.39.12-linux-arm64";
      hash = "sha256-JUtkiXMdyeSGxJL3dob9oaR5PWlvNk0oDLarDexjuJM=";
    };
    aarch64-darwin = fetchurl {
      url = "https://bin.ngrok.com/a/dNynZuhY1VP/ngrok-v3-3.39.12-darwin-arm64";
      hash = "sha256-mb9mYsD9a9Ghzxs0zHbxlFTDMnWNZ/MXNTRNfq+NlMk=";
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
