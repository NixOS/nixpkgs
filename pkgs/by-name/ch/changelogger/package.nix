{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "changelogger";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "MarkusFreitag";
    repo = "changelogger";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-Glup2Y3sGO2hNKFeZXOrffHct2F4Ebn9+f6yOy3pekY=";
  };

  vendorHash = "sha256-f6ojMri3m3pwLXbLnNbS/Xl2lqo0eEHLGbbT5KR1Clc=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/MarkusFreitag/changelogger/cmd.BuildVersion=${finalAttrs.version}"
    "-X github.com/MarkusFreitag/changelogger/cmd.BuildDate=1970-01-01T00:00:00"
  ];

  preCheck = ''
    # Test needs gitconfig
    substituteInPlace pkg/gitconfig/gitconfig_test.go \
      --replace-fail "TestGetGitAuthor" "SkipGetGitAuthor"
  '';

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd changelogger \
      --bash <($out/bin/changelogger completion bash) \
      --fish <($out/bin/changelogger completion fish) \
      --zsh <($out/bin/changelogger completion zsh)
  '';

  meta = {
    changelog = "https://github.com/MarkusFreitag/changelogger/blob/v${finalAttrs.version}/CHANGELOG.md";
    description = "Tool to manage your changelog file in Markdown";
    homepage = "https://github.com/MarkusFreitag/changelogger";
    license = lib.licenses.mit;
    mainProgram = "changelogger";
    maintainers = with lib.maintainers; [ hythera ];
  };
})
