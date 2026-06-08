{
  fetchFromGitHub,
  lib,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  stdenvNoCC,
  nodejs,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "sketchybar-app-font";
  version = "2.0.60";

  src = fetchFromGitHub {
    owner = "kvndrsslr";
    repo = "sketchybar-app-font";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6fi3v+h3i5J1j4xDP1QUlGfrY8o9kiXtMCWmYZ9zgng=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 4;
    hash = "sha256-C8kPbREUf2jAVLBvKtdCsVxDcY7r8Yrq8uAWY9r/8QI=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm_10
  ];

  buildPhase = ''
    runHook preBuild

    pnpm i
    pnpm run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 dist/sketchybar-app-font.ttf "$out/share/fonts/truetype/sketchybar-app-font.ttf"
    install -Dm755 dist/icon_map.sh "$out/bin/icon_map.sh"
    install -Dm644 dist/icon_map.lua "$out/lib/sketchybar-app-font/icon_map.lua"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Ligature-based symbol font and a mapping function for sketchybar";
    longDescription = ''
      A ligature-based symbol font and a mapping function for sketchybar, inspired by simple-bar's usage of community-contributed minimalistic app icons.
    '';
    homepage = "https://github.com/kvndrsslr/sketchybar-app-font";
    changelog = "https://github.com/kvndrsslr/sketchybar-app-font/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [ khaneliman ];
    platforms = lib.platforms.all;
  };
})
