{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lazycli";
  version = "0.1.15-unstable-2022-11-15";

  src = fetchFromGitHub {
    owner = "jesseduffield";
    repo = "lazycli";
    rev = "40c32e74b406152404375e58dbef4036d3ab3197";
    hash = "sha256-k/iPcxVuLZhveVkFaeMMLASHCB+Ccrxr8mwPNqfknvQ=";
  };

  cargoHash = "sha256-DSff1jJ+0W7+Ul+3D2DVe0XTKObyuJ0APU5UbrfHSFA=";

  meta = {
    description = "Tool to static turn CLI commands into TUIs";
    homepage = "https://github.com/jesseduffield/lazycli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tomasrivera ];
    mainProgram = "lazycli";
  };
})
