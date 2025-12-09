{
  lib,
  fetchCrate,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "changelogging";
  version = "0.7.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-orTUCBHacD0MQNfhOUWdh9RxT/9YNvgfCHFDr2eNQic=";
  };

  cargoHash = "sha256-2uYNwKjD0vX+C2Sj2epyTqe4sMqPa7cwVwoUHs3vtQE=";

  passthru.updateScript = nix-update-script { };

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "CLI tool for building changelogs from fragments";
    homepage = "https://github.com/nekitdev/changelogging";
    changelog = "https://github.com/nekitdev/changelogging/releases/tag/v${version}";
    platforms = lib.platforms.all;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.nekitdev ];
    mainProgram = "changelogging";
  };
}
