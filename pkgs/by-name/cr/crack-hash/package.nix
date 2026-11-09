{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "crack-hash";
  version = "1.2.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "kOaDT";
    repo = "crack-hash";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TfGjv/WDqqKHGp1EXa9416YhnItoOd2bLY/V5BdXqfA=";
  };

  cargoHash = "sha256-Duv1179DFPS066pd/l6Y2FYN+aLz8jYHDObAlBqlaKw=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Hash cracking tool";
    homepage = "https://github.com/kOaDT/crack-hash";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "crack-hash";
  };
})
