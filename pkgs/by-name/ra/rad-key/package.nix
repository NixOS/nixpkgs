{
  lib,
  rustPlatform,
  fetchFromRadicle,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rad-key";
  version = "0.1.1";
  __structuredAttrs = true;

  src = fetchFromRadicle {
    seed = "radicle.defelo.de";
    repo = "zFF3JpT1VrrsDYogDPtVZMHw6P4x";
    tag = "releases/${finalAttrs.version}";
    hash = "sha256-0lPVkgBHfIG4fF/JuEnRznnHR9VaX91UBjmHqoFj2rk=";
  };

  cargoHash = "sha256-W/4h+hvsmydZim4HrylLWADINRcwP8cOgoBtPbuSxKY=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Convert between Radicle identities and public SSH keys";
    homepage = "https://radicle.defelo.de/nodes/radicle.defelo.de/rad:zFF3JpT1VrrsDYogDPtVZMHw6P4x";
    license = lib.licenses.mit;
    teams = [ lib.teams.radicle ];
    mainProgram = "rad-key";
  };
})
