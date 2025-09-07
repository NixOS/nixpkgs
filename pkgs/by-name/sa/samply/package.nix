{
  lib,
  rustPlatform,
  fetchCrate,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "samply";
  version = "0.13.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-zTwAsE6zXY3esO7x6UTCO2DbzdUSKZ6qc5Rr9qcI+Z8=";
  };

  cargoHash = "sha256-mQykzO9Ldokd3PZ1fY4pK/GtLmYMVas2iHj1Pqi9WqQ=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command line profiler for macOS and Linux";
    homepage = "https://github.com/mstange/samply";
    changelog = "https://github.com/mstange/samply/releases/tag/samply-v${version}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ figsoda ];
    mainProgram = "samply";
  };
}
