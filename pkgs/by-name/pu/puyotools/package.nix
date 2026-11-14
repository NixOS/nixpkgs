{
  lib,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  nix-update-script,
  versionCheckHook,
}:

buildDotnetModule (finalAttrs: {
  pname = "puyotools";
  version = "3.0.0-dev";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "nickworonekin";
    repo = "puyotools";
    tag = finalAttrs.version;
    hash = "sha256-4V0g7ccFpemr1XUl5x95wrw6evpCBrlwX/y+VdMYP+I=";
  };

  doCheck = false;
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  dotnet-runtime = dotnetCorePackages.runtime_10_0;
  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  executables = [ "PuyoToolsCli" ];
  nugetDeps = ./deps.json;
  projectFile = "src/PuyoTools.App.Cli/PuyoTools.App.Cli.csproj";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-line tool for compressed files, archives and textures used in Puyo Puyo and other games";
    homepage = "https://github.com/nickworonekin/puyotools";
    changelog = "https://github.com/nickworonekin/puyotools/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ keenanweaver ];
    mainProgram = "PuyoToolsCli";
  };
})
