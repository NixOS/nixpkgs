{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "jaq";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "01mf02";
    repo = "jaq";
    tag = "v${version}";
    hash = "sha256-J+48TWGio6KplqYFJM25LGIuf+yAyE7NMqgPUPgpTeY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-hgbRDsm9qghvUpKaFMr7keHEk9TUYRVZnnWouky/Zm8=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Jq clone focused on correctness, speed and simplicity";
    homepage = "https://github.com/01mf02/jaq";
    changelog = "https://github.com/01mf02/jaq/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      figsoda
      siraben
    ];
    mainProgram = "jaq";
  };
}
