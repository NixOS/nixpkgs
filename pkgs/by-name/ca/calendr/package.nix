{
  lib,
  fetchurl,
  stdenvNoCC,
  unzip,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "calendr";
  version = "1.22.2";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://github.com/pakerwreah/Calendr/releases/download/v${finalAttrs.version}/Calendr.zip";
    hash = "sha256-gJvVB0PzPrQVVRKb69laYrHnj3dpwRJXhzPdO+zLl7E=";
  };

  nativeBuildInputs = [ unzip ];

  sourceRoot = "Calendr.app";

  installPhase = ''
    mkdir -p "$out/Applications/Calendr.app"
    cp -R . "$out/Applications/Calendr.app"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/pakerwreah/Calendr/releases/tag/v${finalAttrs.version}";
    description = "Menu bar calendar for macOS";
    homepage = "https://github.com/pakerwreah/Calendr";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ philocalyst ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
