{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "hammerspoon";
  version = "1.1.0";

  src = fetchurl {
    url = "https://github.com/Hammerspoon/hammerspoon/releases/download/${finalAttrs.version}/Hammerspoon-${finalAttrs.version}.zip";
    hash = "sha256-Oe+Qe3mE9s04d41b7jdyq6yL5rSKpGof9detzNQec7U=";
  };

  nativeBuildInputs = [ unzip ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r Hammerspoon.app $out/Applications

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Staggeringly powerful macOS desktop automation with Lua";
    homepage = "https://www.hammerspoon.org";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [
      bearoffwork
    ];
    platforms = lib.platforms.darwin;
  };
})
