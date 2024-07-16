{ buildGoModule
, fetchFromGitHub
, installShellFiles
, lib
, versionCheckHook
}:
let
  pname = "dependabot-cli";
  version = "1.41.0";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "dependabot";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-CnSDvLcLupWKBp1Wr6E9BScA8VsBlfmmfPwh8cyERZg=";
  };

  vendorHash = "sha256-vN5r1OtHT16LeJ6iPmHmXTx9Oo+WALhV4PWqzMiUwSA=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/dependabot/cli/cmd/dependabot/internal/cmd.version=v${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd dependabot \
      --bash <($out/bin/dependabot completion bash) \
      --fish <($out/bin/dependabot completion fish) \
      --zsh <($out/bin/dependabot completion zsh)
  '';

  checkFlags = [
    "-skip=TestIntegration|TestNewProxy_customCert|TestRun"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  versionCheckProgram = "dependabot";

  meta = with lib; {
    changelog = "https://github.com/dependabot/cli/releases/tag/v${version}";
    description = "Tool for testing and debugging Dependabot update jobs";
    mainProgram = "dependabot";
    homepage = "https://github.com/dependabot/cli";
    license = licenses.mit;
    maintainers = with maintainers; [ l0b0 ];
  };
}
