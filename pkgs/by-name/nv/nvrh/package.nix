{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule rec {
  pname = "nvrh";
  version = "0.1.15";

  src = fetchFromGitHub {
    owner = "mikew";
    repo = "nvrh";
    rev = "refs/tags/v${version}";
    hash = "sha256-FLlSS/ZgoGT4SyBG/sKdrN3eBSJdT0qFeGl01y4P/So=";
  };

  postPatch = ''
    substituteInPlace go.mod \
      --replace-fail "go 1.23.1" "go 1.22.7"
  '';

  preBuild = ''
    cp manifest.json src/
  '';

  vendorHash = "sha256-DuGMlRdVUMKwghPQjVP3A+epnsA5a15jl84Y8LTPkTM=";

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
