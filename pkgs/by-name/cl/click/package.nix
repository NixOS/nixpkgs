{
  fetchFromGitHub,
  rustPlatform,
  lib,
  stdenv,
  pkg-config,
  openssl,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "click";
  version = "0.6.3";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "databricks";
    repo = "click";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tYSbyDipZg6Qj/CWk1QVUT5AG8ncTt+5V1+ekpmsKXA=";
  };

  cargoHash = "sha256-K9+SGpWcsOy0l8uj1z6AQggZq+M7wHARACFxsZ6vbUo=";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ pkg-config ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ openssl ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Command Line Interactive Controller for Kubernetes";
    homepage = "https://github.com/databricks/click";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.mbode ];
    mainProgram = "click";
  };
})
