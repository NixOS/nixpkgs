{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "gowitness";
  version = "3.2.2";

  src = fetchFromGitHub {
    owner = "sensepost";
    repo = "gowitness";
    tag = finalAttrs.version;
    hash = "sha256-nd9tlUEqKmPsSXWiH2FiQNs78H2YK9ld/qmJ+MCTuYU=";
  };

  vendorHash = "sha256-CVQNidHA4H0pPHuwMw2DPVgLeuzoJE8mewsgp0o4EIA=";

  ldflags = [
    "-s"
    "-w"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  meta = {
    description = "Web screenshot utility";
    homepage = "https://github.com/sensepost/gowitness";
    changelog = "https://github.com/sensepost/gowitness/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "gowitness";
  };
})
