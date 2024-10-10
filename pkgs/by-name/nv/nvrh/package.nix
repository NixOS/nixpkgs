{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule rec {
  pname = "nvrh";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "mikew";
    repo = "nvrh";
    rev = "refs/tags/v${version}";
    hash = "sha256-a/TFSS4PeZWEYph4B8qDr4BJPY4CnHafvw07t1ytofo=";
  };

  postPatch = ''
    substituteInPlace go.mod \
      --replace-fail "go 1.23.1" "go 1.22.7"
  '';

  preBuild = ''
    cp manifest.json src/
  '';

  vendorHash = "sha256-Ao2BrB6fUOw2uFziQWNKeVTZtIeoW0MP7aLyuI1J3ng=";

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
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Aims to be similar to VSCode Remote, but for Neovim";
    homepage = "https://github.com/mikew/nvrh";
    changelog = "https://github.com/mikew/nvrh/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "nvrh";
  };
}
