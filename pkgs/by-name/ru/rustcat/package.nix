{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "rustcat";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "robiot";
    repo = "rustcat";
    tag = "v${version}";
    hash = "sha256-/6vNFh7n6WvYerrL8m9sgUKsO2KKj7/f8xc4rzHy9Io=";
  };

  cargoHash = "sha256-76/JK9IKYD6mxMddUyTgKAw53GM4EUhC0NbKFKdg8CI=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  versionCheckProgram = [ "${placeholder "out"}/bin/rcat" ];

  meta = {
    description = "Port listener and reverse shell";
    homepage = "https://github.com/robiot/rustcat";
    changelog = "https://github.com/robiot/rustcat/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "rcat";
  };
}
