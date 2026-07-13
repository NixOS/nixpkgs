{
  lib,
  stdenvNoCC,
  fetchurl,
}:

let
  versionMetadata = import ./sources.nix;
  source =
    versionMetadata.sources.${stdenvNoCC.hostPlatform.system}
      or (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}");
in
stdenvNoCC.mkDerivation {
  pname = "chainctl";
  version = versionMetadata.version;

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl {
    inherit (source) url hash;
  };

  dontUnpack = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 $src $out/bin/chainctl
    ln -s chainctl $out/bin/docker-credential-cgr

    runHook postInstall
  '';

  doInstallCheck = stdenvNoCC.buildPlatform.canExecute stdenvNoCC.hostPlatform;

  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/chainctl version

    runHook postInstallCheck
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "CLI for the Chainguard platform";
    homepage = "https://edu.chainguard.dev/platform/chainctl/chainctl-docs/chainctl/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ _0hlov3 ];
    mainProgram = "chainctl";
    platforms = lib.attrNames versionMetadata.sources;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
