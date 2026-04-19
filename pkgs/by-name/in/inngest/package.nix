{
  lib,
  stdenvNoCC,
  fetchurl,
  nix-update-script,
}:

let
  sources = {
    x86_64-linux = {
      os = "linux";
      arch = "amd64";
      hash = "sha256-Vh9uCOBNzdKfZngrhupWjntWMJvNBzYg/sGPGaBoOeI=";
    };
    aarch64-linux = {
      os = "linux";
      arch = "arm64";
      hash = "sha256-iM6sackbdmz6Sbge2Xjx8kNlZ6uyUToE2NiojlSn82s=";
    };
    x86_64-darwin = {
      os = "darwin";
      arch = "amd64";
      hash = "sha256-9gbox1f9nABWf/KP7QIJDBqWk6VR+sosJuY7HmwHC9g=";
    };
    aarch64-darwin = {
      os = "darwin";
      arch = "arm64";
      hash = "sha256-uk4e0/gOVEJFAr1Z2eVzCf8abR8IPHbYadQKmH5Y97w=";
    };
  };

  source =
    sources.${stdenvNoCC.hostPlatform.system}
      or (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}");
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "inngest";
  version = "1.17.9";

  src = fetchurl {
    url = "https://github.com/inngest/inngest/releases/download/v${finalAttrs.version}/inngest_${finalAttrs.version}_${source.os}_${source.arch}.tar.gz";
    inherit (source) hash;
  };

  sourceRoot = ".";

  strictDeps = true;
  __structuredAttrs = true;

  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 inngest $out/bin/inngest

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI and dev server for Inngest durable workflows";
    homepage = "https://github.com/inngest/inngest";
    changelog = "https://github.com/inngest/inngest/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.sspl;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "inngest";
    platforms = lib.attrNames sources;
    maintainers = [ ];
  };
})
