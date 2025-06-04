{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "iwe";
  version = "0.0.32";

  src = fetchFromGitHub {
    owner = "iwe-org";
    repo = "iwe";
    tag = "iwe-v${finalAttrs.version}";
    hash = "sha256-3LXMRHenm6+CU2fK3IPA5bX/jbAk4qTvfPgCydXIRLw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-cYKLBMf1vO/3GpZ/g0FcjdmX0DDVzDDTChv8+IVzkAo=";

  cargoBuildFlags = [
    "--package=iwe"
    "--package=iwes"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^iwe-v(.*)$"
    ];
  };

  meta = {
    description = "Personal knowledge management system (editor plugin & command line utility)";
    homepage = "https://iwe.md/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      phrmendes
      HeitorAugustoLN
    ];
    mainProgram = "iwe";
  };
})
