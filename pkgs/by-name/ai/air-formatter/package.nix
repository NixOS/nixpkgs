{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "air-formatter";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "posit-dev";
    repo = "air";
    tag = finalAttrs.version;
    hash = "sha256-32/wdz4CFYM/PFVSQiqYErXGHHn2KJyreiQq48vQryY=";
  };

  # Remove duplicate entries from cargo lock
  cargoPatches = [ ./cargo-lock.patch ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-zPT47K8OGtprxQt3ZOF2xmf6IRV5rsKWXeaXlyBdVlE=";

  useNextest = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/air";
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "An extremely fast R code formatter";
    homepage = "https://posit-dev.github.io/air";
    changelog = "https://github.com/posit-dev/air/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.kupac ];
    mainProgram = "air";
  };
})
