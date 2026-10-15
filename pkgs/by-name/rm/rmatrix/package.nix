{
  rustPlatform,
  fetchFromGitHub,
  lib,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rmatrix";
  version = "0.3.3";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Tripstack-Corp";
    repo = "rmatrix";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sViNj7paMY/3x9u6dKHKf+XQRgv+EYsYsooZSTAwrA4=";
  };

  cargoHash = "sha256-em16fNb4BZeTsZuaT5Bu/u2cc75iSjOcSDYU0qazefM=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Digital rain for modern terminals";
    maintainers = with lib.maintainers; [ yarn ];
    platforms = lib.platforms.all;
    license = lib.licenses.mit;
    homepage = "https://github.com/Tripstack-Corp/rmatrix";
    mainProgram = "rmatrix";
  };
})
