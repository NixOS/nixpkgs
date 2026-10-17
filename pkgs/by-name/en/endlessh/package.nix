{
  lib,
  stdenv,
  fetchFromGitHub,
  versionCheckHook,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "endlessh";
  version = "1.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "skeeto";
    repo = "endlessh";
    tag = finalAttrs.version;
    hash = "sha256-yHQzDrjZycDL/2oSQCJjxbZQJ30FoixVG1dnFyTKPH4=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-V";
  doInstallCheck = true;

  passthru.tests = {
    inherit (nixosTests) endlessh;
  };

  meta = {
    description = "SSH tarpit that slowly sends an endless banner";
    homepage = "https://github.com/skeeto/endlessh";
    changelog = "https://github.com/skeeto/endlessh/releases/tag/${finalAttrs.version}";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ azahi ];
    platforms = lib.platforms.unix;
    mainProgram = "endlessh";
  };
})
