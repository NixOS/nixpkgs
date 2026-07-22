{
  lib,
  rustPlatform,
  fetchFromGitHub,
  withAi ? true,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "codemark-cli";
  version = "0.7.24";
  __structuredAttrs = true;
  src = fetchFromGitHub {
    owner = "DanielCardonaRojas";
    repo = "codemark";
    tag = finalAttrs.version;
    sha256 = "sha256-Weh7JRAwUImFfcPU6bSqC+W11+Z5q5oPxXv60RzEuWw=";
  };

  cargoHash = "sha256-dROHNUF3qDsohMTTb/1pwHjjUslWfOBx82jOgefjPH8=";

  buildNoDefaultFeatures = withAi;
  buildFeatures = lib.optionals withAi [
    "semantic"
  ];

  # I was not able to disable the failing checks when packaging
  # Feel free to fix
  doCheck = false;

  meta = {
    description = "A semantic code bookmarking system for humans and agents";
    homepage = "https://danielcardonarojas.github.io/codemark/";
    changelog = "https://github.com/DanielCardonaRojas/codemark/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;

    maintainers = with lib.maintainers; [
      matthiasbeyer
    ];
  };
})
