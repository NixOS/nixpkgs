{
  rustPlatform,
  fetchFromGitHub,
  lib,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rmatrix";
  version = "0.4.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Tripstack-Corp";
    repo = "rmatrix";
    tag = "v${finalAttrs.version}";
    hash = "sha256-l1sL2uiLsXj9FXNIXJFUMd9WKHrTNBJvOsuaZSRL84A=";
  };

  cargoHash = "sha256-IuV1/DdowSGoxzXUHyR3DLwmvRdGidrZPfTketjxLz8=";

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
