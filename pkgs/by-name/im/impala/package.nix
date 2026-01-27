{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "impala";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "pythops";
    repo = "impala";
    rev = "v${finalAttrs.version}";
    hash = "sha256-kDXf+zrCfsYv+5P69BiZDBqaw9SM3JPCXV7KzpIEJn0=";
  };

  cargoHash = "sha256-Zs3x7wWbO0LL1BjEAWb1UbztJJ6K6hXxgMBynHLri8A=";

  # fix for compilation of musl builds on aarch64
  # see https://github.com/NixOS/nixpkgs/issues/145726
  postPatch = ''
    rm .cargo/config.toml
  '';

  meta = {
    description = "TUI for managing wifi";
    homepage = "https://github.com/pythops/impala";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      nydragon
      saadndm
    ];
    mainProgram = "impala";
  };
})
