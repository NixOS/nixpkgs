{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "complgen";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "adaszko";
    repo = "complgen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cJKcyq5zV4eJboYz4l0NoGKhMilk6aPz3j3E2G+7yoU=";
  };

  cargoHash = "sha256-2asHTHbh8V2Or+crjNCNNiUN2CGmmsHSJ9XZHKuZhP8=";

  meta = {
    changelog = "https://github.com/adaszko/complgen/blob/v${finalAttrs.version}/CHANGELOG.md";
    description = "Generate {bash,fish,zsh} completions from a single EBNF-like grammar";
    homepage = "https://github.com/adaszko/complgen";
    license = lib.licenses.asl20;
    mainProgram = "complgen";
    maintainers = with lib.maintainers; [ hythera ];
  };
})
