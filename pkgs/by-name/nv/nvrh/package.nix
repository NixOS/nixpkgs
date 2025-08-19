{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "nvrh";
  version = "0.1.23";

  src = fetchFromGitHub {
    owner = "mikew";
    repo = "nvrh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9pWeoFah8bxbngqETgi8uGbvUqKUhdiRHmOuxpPmJNs=";
  };

  vendorHash = "sha256-DuGMlRdVUMKwghPQjVP3A+epnsA5a15jl84Y8LTPkTM=";

  preBuild = ''
    cp manifest.json src/
  '';

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    mv $out/bin/src $out/bin/nvrh
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Aims to be similar to VSCode Remote, but for Neovim";
    homepage = "https://github.com/mikew/nvrh";
    changelog = "https://github.com/mikew/nvrh/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "nvrh";
  };
})
