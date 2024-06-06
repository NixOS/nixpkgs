{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage {
  pname = "piped-proxy";
  version = "0-unstable-2024-07-13";

  src = fetchFromGitHub {
    owner = "TeamPiped";
    repo = "piped-proxy";
    rev = "91ad17aeb3cc21b011dd7cb6cadffdb9f15db196";
    hash = "sha256-6hFq68VL2BhEzfU/R9TeMMR7vP29bVX9/Ci3zOz4onE=";
  };

  cargoHash = "sha256-d13I/YBbyms6MoXXcKkE6P3n9Tu7I2X1HP0eZHlhbuI=";

  meta = {
    description = "A proxy for Piped written in Rust";
    homepage = "https://github.com/TeamPiped/piped-proxy";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [defelo];
  };
}
