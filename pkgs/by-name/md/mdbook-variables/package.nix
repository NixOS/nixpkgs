{
  lib,
  rustPlatform,
  fetchFromGitLab,
  versionCheckHook,
}:
rustPlatform.buildRustPackage rec {
  pname = "mdbook-variables";
  version = "0.4.0";

  src = fetchFromGitLab {
    owner = "tglman";
    repo = "mdbook-variables";
    rev = version;
    hash = "sha256-zverdL4Mrnn/8pxQk6qVyidPJNxnrmaETt+XTp64Rns=";
  };

  cargoHash = "sha256-/zp5Qj2NUVpQqKAFgQP4QatYzg/hMJQE08ANacvNPko=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    description = "mdBook preprocessor to replace values with env variables";
    mainProgram = "mdbook-variables";
    homepage = "https://gitlab.com/tglman/mdbook-variables";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ kraftnix ];
  };
}
