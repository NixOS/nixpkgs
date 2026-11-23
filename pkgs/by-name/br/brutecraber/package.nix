{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  ocl-icd,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "brutecraber";
  version = "0.10.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Erikgavs";
    repo = "brutecraber";
    tag = finalAttrs.version;
    hash = "sha256-i2bhScXYZgdhT15NJYtGmqQXOAqZMlTDVSgkbDIRhfY=";
  };

  cargoHash = "sha256-PY041MrcsFWLQF5fmsdU+YEABcxsXkuvqyWSEM4oxBM=";

  buildInputs = [ ocl-icd ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Hash cracker";
    homepage = "https://github.com/Erikgavs/brutecraber";
    changelog = "https://github.com/Erikgavs/brutecraber/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "brutecraber";
    broken = stdenv.hostPlatform.isDarwin;
  };
})
