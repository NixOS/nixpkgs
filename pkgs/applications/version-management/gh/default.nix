{ lib, fetchFromGitHub, buildGoModule, installShellFiles, stdenv, testers, gh }:

buildGoModule rec {
  pname = "gh";
  version = "2.45.0";

  src = fetchFromGitHub {
    owner = "cli";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-jztBWn/1bDTxR/q27RYJM6boFWyduTKAtIn5zIZK2tU=";
  };

  vendorHash = "sha256-FprVBvYPGWLcUKlWg9JU7yy2KDa/3rceAEHUIYHN4f8=";

  nativeBuildInputs = [ installShellFiles ];

  buildPhase = ''
    runHook preBuild
    make GO_LDFLAGS="-s -w" GH_VERSION=${version} bin/gh ${lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) "manpages"}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 bin/gh -t $out/bin
   '' + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installManPage share/man/*/*.[1-9]

    installShellCompletion --cmd gh \
      --bash <($out/bin/gh completion -s bash) \
      --fish <($out/bin/gh completion -s fish) \
      --zsh <($out/bin/gh completion -s zsh)
  '' + ''
    runHook postInstall
  '';

  # most tests require network access
  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = gh;
  };

  meta = with lib; {
    description = "GitHub CLI tool";
    homepage = "https://cli.github.com/";
    changelog = "https://github.com/cli/cli/releases/tag/v${version}";
    license = licenses.mit;
    mainProgram = "gh";
    maintainers = with maintainers; [ zowoq ];
  };
}
