{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "aaa";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "asciimoth";
    repo = "aaa";
    tag = "${finalAttrs.version}";
    hash = "sha256-LJjpxfSQ+R1oohqROacdT5YrkDyzXzeC/ExqkqSQDaA=";
  };

  cargoHash = "sha256-FMarQiPAtPeo3XmGy9uXSLQsmnw2+uYhe/rJxUvp38w=";

  meta = {
    description = "Swiss Army knife for animated ascii art";
    homepage = "https://github.com/asciimoth/aaa";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ asciimoth ];
    mainProgram = "aaa";
  };
})
