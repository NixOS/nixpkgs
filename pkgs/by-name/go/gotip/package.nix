{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "gotip";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "lusingander";
    repo = "gotip";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QXxewfB7rAVfgCfdLNi9BHus7Mwfehi2JDGueqfHyrg=";
  };

  vendorHash = "sha256-uohgB8eEAvZJP1mh52epyHGvJDOJBQXrQwHIhm+vVT4=";

  ldflags = [
    "-s"
    "-w"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Go test interactive picker";
    homepage = "https://github.com/lusingander/gotip";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "gotip";
  };
})
