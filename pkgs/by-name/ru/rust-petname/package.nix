{
  lib,
  rustPlatform,
  fetchCrate,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rust-petname";
  version = "3.0.0";

  src = fetchCrate {
    inherit (finalAttrs) version;
    crateName = "petname";
    hash = "sha256-RKOW0SDRlMRPlsmWvk+teB14Tdf3tgrP35Glvn/wJBE=";
  };

  cargoHash = "sha256-LMlfYVL6Hk+b7v6qvz0Y1y2awxvcH35+vCvBMvCUEv4=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Generate human readable random names";
    homepage = "https://github.com/allenap/rust-petname";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.progrm_jarvis ];
    mainProgram = "petname";
  };
})
