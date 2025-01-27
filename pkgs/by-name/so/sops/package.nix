{
  lib,
  buildGo122Module,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

buildGo122Module rec {
  pname = "sops";
  version = "3.9.4";

  src = fetchFromGitHub {
    owner = "getsops";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-w2RMK1Fl/k8QXV68j0Kc6shtx4vQa07RCnpgHLM8c8Q=";
  };

  vendorHash = "sha256-wxmSj3QaFChGE+/2my7Oe2mhprwi404izUxteecyggY=";

  postPatch = ''
    substituteInPlace go.mod \
      --replace-fail "go 1.22" "go 1.22.7"
  '';

  subPackages = [ "cmd/sops" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/getsops/sops/v3/version.Version=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd sops --bash ${./bash_autocomplete}
    installShellCompletion --cmd sops --zsh ${./zsh_autocomplete}
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://getsops.io/";
    description = "Simple and flexible tool for managing secrets";
    changelog = "https://github.com/getsops/sops/blob/v${version}/CHANGELOG.rst";
    mainProgram = "sops";
    maintainers = with lib.maintainers; [
      Scrumplex
      mic92
    ];
    license = lib.licenses.mpl20;
  };
}
