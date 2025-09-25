{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gdscript-formatter";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "GDQuest";
    repo = "GDScript-formatter";
    tag = finalAttrs.version;
    hash = "sha256-2xbsQUt5jfWEvhOix+WEK9rP7tb2DZ0BX35YqPpdyuc=";
  };

  cargoHash = "sha256-RqNgPEP/phhobwAl8a3sm5iaiwdTpwdJ8NtnzJPd6uQ=";

  cargoBuildFlags = [
    "--bin=gdscript-formatter"
  ];

  meta = {
    description = "Fast code formatter for GDScript and Godot 4";
    homepage = "https://github.com/GDQuest/GDScript-formatter";
    license = lib.licenses.mit;
    mainProgram = "gdscript-formatter";
    maintainers = with lib.maintainers; [ squarepear ];
  };
})
