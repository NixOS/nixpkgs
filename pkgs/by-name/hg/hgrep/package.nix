{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

let
  version = "0.3.8";
in
rustPlatform.buildRustPackage {
  pname = "hgrep";
  inherit version;

  src = fetchFromGitHub {
    owner = "rhysd";
    repo = "hgrep";
    tag = "v${version}";
    hash = "sha256-GcV6tZLhAtBE0/husOqZ3Gib9nXXg7kcxrNp9IK0eTo=";
  };

  cargoHash = "sha256-NxfWY9OoMNASlWE48njuAdTI11JAV+rzjD0OU2cHLsc=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Grep with human-friendly search results";
    homepage = "https://github.com/rhysd/hgrep";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ axka ];
    mainProgram = "hgrep";
  };
}
