{
  lib,
  stdenv,
  fetchurl,
  testers,
}:

let
  version = "3.39.9";
  sources = {
    i686-linux = fetchurl {
      url = "https://bin.ngrok.com/a/hFGVDX3b1g9/ngrok-v3-3.39.9-linux-386";
      hash = "sha256-D4OW6ByClQBO1YtBgydamen19DM5KXsqsgDU954Xtg8=";
    };
    x86_64-linux = fetchurl {
      url = "https://bin.ngrok.com/a/58nxNCjvFS5/ngrok-v3-3.39.9-linux-amd64";
      hash = "sha256-0mw/peLKVlzudwAekqGUDr7Lzwz54vitQxmkKaqhvz8=";
    };
    aarch64-linux = fetchurl {
      url = "https://bin.ngrok.com/a/7VJKVAoYV2h/ngrok-v3-3.39.9-linux-arm64";
      hash = "sha256-FEpZp6Fq02eH57VKa/5qdpuCcAECqavtOzdO5Q3eYXk=";
    };
    aarch64-darwin = fetchurl {
      url = "https://bin.ngrok.com/a/j4HD3vGPY91/ngrok-v3-3.39.9-darwin-arm64";
      hash = "sha256-DsgC5RJWa67rcOdkgwtB737uSnywdAfSCYvjtY1tojY=";
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
