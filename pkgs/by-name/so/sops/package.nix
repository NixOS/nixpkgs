{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule rec {
  pname = "sops";
  version = "3.10.0";

  src = fetchFromGitHub {
    owner = "getsops";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-NOZvVL4b7+TVlB6iM4HJDa5PHOjvcN0BXDMOHmqg7lU=";
  };

  vendorHash = "sha256-I+iwimrNdKABZFP2etZTQJAXKigh+0g/Jhip86Cl5Rg=";

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
