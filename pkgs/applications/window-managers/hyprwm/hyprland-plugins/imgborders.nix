{
  lib,
  fetchFromCodeberg,
  mkHyprlandPlugin,
  cmake,
  nix-update-script,
}:
mkHyprlandPlugin {
  pluginName = "imgborders";
  version = "2.0.0-unstable-2026-08-16";

  src = fetchFromCodeberg {
    owner = "zacoons";
    repo = "imgborders";
    rev = "08be22236144d3c91607bcfa955ed0d457f4f50b";
    hash = "sha256-O+896T2qrisxiWTotB5HlzKw8XEJqPDTgSUHAAVUD18=";
  };

  nativeBuildInputs = [
    cmake
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    homepage = "https://codeberg.org/zacoons/imgborders";
    description = "Add tiling image borders to windows!";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [
      mrdev023
    ];
  };
}
