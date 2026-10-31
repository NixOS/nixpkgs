{
  lib,
  stdenvNoCC,
  nodejs,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,

  # Passed in by package.nix as `inherit (finalAttrs) src version;`, so the
  # frontend is always built from the exact same checkout as the C++ and can
  # never drift from it.
  src,
  version,
}:

# stdenvNoCC: this is a pure JS/TS build, nothing here is ever compiled.
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "bambu-studio-device-page";
  inherit version src;

  # The frontend is a subdirectory of the BambuStudio checkout, with its own
  # package.json/pnpm-lock.yaml.
  sourceRoot = "${finalAttrs.src.name}/src/slic3r/GUI/DeviceWeb/device_page";

  nativeBuildInputs = [
    nodejs
    pnpm_10
    pnpmConfigHook
  ];

  # pnpm 10, not the nixpkgs-default pnpm_11: upstream's package.json pins
  # "packageManager": "pnpm@10.12.1" and the lockfile is lockfileVersion 9.0.
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      sourceRoot
      ;
    pnpm = pnpm_10;
    fetcherVersion = 4;
    hash = "sha256-4hpdGeC+SQgGZl0M6KI7Del2TErIU/T6cuza7/GNUE0=";
  };

  buildPhase = ''
    runHook preBuild
    pnpm run build
    runHook postBuild
  '';

  # vite.config.ts sets `base: './'` so the bundle loads over file://, which
  # is how BambuStudio's embedded WebView opens it.
  installPhase = ''
    runHook preInstall
    cp -r dist $out
    runHook postInstall
  '';

  meta = {
    description = "Prebuilt device_page (Filament Manager) web bundle for BambuStudio";
    homepage = "https://github.com/bambulab/BambuStudio";
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.linux;
  };
})
