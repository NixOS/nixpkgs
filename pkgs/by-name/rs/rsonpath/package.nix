{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rsonpath";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "rsonquery";
    repo = "rsonpath";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pgKqVDDaJ8vcDOp0FuuuBkShQDFP3x6BVS7x8ZZawAY=";
  };

  cargoHash = "sha256-PC35k3vwKP55VKZt1txKVajhfrJpFiEgJYA4lNe/U7U=";

  cargoBuildFlags = [ "-p=rsonpath" ];
  cargoTestFlags = finalAttrs.cargoBuildFlags;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Experimental JSONPath engine for querying massive streamed datasets";
    homepage = "https://github.com/v0ldek/rsonpath";
    changelog = "https://github.com/v0ldek/rsonpath/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      tbutter
      progrm_jarvis
    ];
    mainProgram = "rq";
  };
})
