{
  lib,
  rustPlatform,
  fetchFromGitHub,
  enableLTO ? true,
  nrxAlias ? true,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nrr";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "ryanccn";
    repo = "nrr";
    rev = "v${finalAttrs.version}";
    hash = "sha256-wkt2F7drBxi4AJhJXvlxpD/CVZuQ2M3wL6IqZ72m3vI=";
  };

  cargoHash = "sha256-uOPkTAypThZPof2DaBS/uGJThlV179jNj0SkSJ0X6r8=";

  env = lib.optionalAttrs enableLTO {
    CARGO_PROFILE_RELEASE_LTO = "fat";
    CARGO_PROFILE_RELEASE_CODEGEN_UNITS = "1";
  };

  postInstall = lib.optionalString nrxAlias "ln -s $out/bin/nr{r,x}";

  meta = {
    description = "Minimal, blazing fast npm scripts runner";
    homepage = "https://github.com/ryanccn/nrr";
    maintainers = with lib.maintainers; [ ryanccn ];
    license = lib.licenses.gpl3Only;
    mainProgram = "nrr";
  };
})
