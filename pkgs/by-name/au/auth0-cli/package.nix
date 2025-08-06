{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
}:

buildGoModule rec {
  pname = "auth0-cli";
  version = "1.16.0";

  src = fetchFromGitHub {
    owner = "auth0";
    repo = "auth0-cli";
    tag = "v${version}";
    hash = "sha256-iTtjjqONnSmOlaBHOq1SgsbNiKVSKCePg5CJfZs4r/4=";
  };

  vendorHash = "sha256-e5/9AA68p1byqwUOK5/t4L3WQ/td9BYiNfFDD5NbTeU=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/auth0/auth0-cli/internal/buildinfo.Version=v${version}"
    "-X=github.com/auth0/auth0-cli/internal/buildinfo.Revision=0000000"
  ];

  preCheck = ''
    # Feed in all tests for testing
    # This is because subPackages above limits what is built to just what we
    # want but also limits the tests
    unset subPackages
    # Test requires network access
    substituteInPlace internal/cli/universal_login_customize_test.go \
      --replace-fail "TestFetchUniversalLoginBrandingData" "SkipFetchUniversalLoginBrandingData"
  '';

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd auth0 \
      --bash <($out/bin/auth0 completion bash) \
      --fish <($out/bin/auth0 completion fish) \
      --zsh <($out/bin/auth0 completion zsh)
  '';

  subPackages = [ "cmd/auth0" ];

  meta = {
    description = "Supercharge your developer workflow";
    homepage = "https://auth0.github.io/auth0-cli";
    changelog = "https://github.com/auth0/auth0-cli/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ matthewcroughan ];
    mainProgram = "auth0";
  };
}
