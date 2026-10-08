{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "anewer";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "ysf";
    repo = "anewer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FyK0AvwGAFmxswrf42ZBzYCZdZ7X0goQRCUpqFOTD9o=";
  };

  cargoHash = "sha256-7qOfGHS9WPsdBUOjWztkIrkr+krfw84aEf9+5fvmhXM=";

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Append lines from stdin to a file if they don't already exist in the file";
    mainProgram = "anewer";
    homepage = "https://github.com/ysf/anewer";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ tomasrivera ];
  };
})
