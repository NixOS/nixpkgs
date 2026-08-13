{
  lib,
  fetchFromCodeberg,
  mkHyprlandPlugin,
  cmake,
  nix-update-script,
}:
mkHyprlandPlugin {
  pluginName = "imgborders";
  version = "1.0.2-unstable-2026-05-17";

  src = fetchFromCodeberg {
    owner = "zacoons";
    repo = "imgborders";
    rev = "a20b4d36d01f82823ba3749db95c91743d26f656";
    hash = "sha256-e3PiaR7G6l/lMJ41xtSPcfMKhZcx8UHj13lr0u+8JAk=";
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
