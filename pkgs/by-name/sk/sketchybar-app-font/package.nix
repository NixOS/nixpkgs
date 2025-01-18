{
  fetchFromGitHub,
  lib,
  pnpm_9,
  stdenvNoCC,
  nodejs,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "sketchybar-app-font";
  version = "2.0.29";

  src = fetchFromGitHub {
    owner = "kvndrsslr";
    repo = "sketchybar-app-font";
    rev = "v2.0.29";
    hash = "sha256-8SWN22pjHnXWM+RUEYNux0ZWhRUVMib3M7r2SlI33tQ=";
  };

  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-NGAgueJ+cuK/csjdf94KNklu+Xf91BHoWKVgEctX6eA=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_9.configHook
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
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [ khaneliman ];
    platforms = lib.platforms.all;
  };
})
