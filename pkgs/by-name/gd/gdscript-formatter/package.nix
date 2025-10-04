{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gdscript-formatter";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "GDQuest";
    repo = "GDScript-formatter";
    tag = finalAttrs.version;
    hash = "sha256-ow21z4eM3c6CiOutrMQoxiT8A8r05GXLORIcEgvi9b4=";
    deepClone = true;
  };

  cargoHash = "sha256-pc+nvVDfo29NWyBl0qy9baAExtPoXPFcGf3b7mgupvg=";

  cargoBuildFlags = [
    "--bin=gdscript-formatter"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast code formatter for GDScript and Godot 4";
    homepage = "https://github.com/GDQuest/GDScript-formatter";
    license = lib.licenses.mit;
    mainProgram = "gdscript-formatter";
    maintainers = with lib.maintainers; [ squarepear ];
  };
})
