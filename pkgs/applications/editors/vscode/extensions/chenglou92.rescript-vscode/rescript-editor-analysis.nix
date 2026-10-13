{
  lib,
  fetchFromGitHub,
  nix-update-script,
  ocamlPackages,
}:

ocamlPackages.buildDunePackage (finalAttrs: {
  pname = "analysis";
  version = "1.72.0";

  minimalOCamlVersion = "4.10";

  src = fetchFromGitHub {
    owner = "rescript-lang";
    repo = "rescript-vscode";
    tag = finalAttrs.version;
    hash = "sha256-bGCQ/HC6ItQMR0v0wLsF9pNX/Y1sBnp7E+Am0flWhGk=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    ocamlPackages.cppo
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "([0-9]+\\.[0-9]+\\.[0-9]+)"
    ];
  };

  meta = {
    description = "Analysis binary for the ReScript VSCode plugin";
    homepage = "https://github.com/rescript-lang/rescript-vscode";
    changelog = "https://github.com/rescript-lang/rescript-vscode/releases/tag/${finalAttrs.version}";
    maintainers = with lib.maintainers; [
      jayesh-bhoot
      RossSmyth
    ];
    license = lib.licenses.mit;
    mainProgram = "rescript-editor-analysis";
  };
})
