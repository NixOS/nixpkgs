{
  lib,
  fetchFromGitHub,
  buildGo126Module,
  installShellFiles,
  stdenv,
  testers,
  gh,
  makeWrapper,
}:

buildGo126Module rec {
  pname = "gh";
  version = "2.93.0";

  src = fetchFromGitHub {
    owner = "cli";
    repo = "cli";
    tag = "v${version}";
    hash = "sha256-r/+JFdMOUIb32St+VkUw+Q7Lb2L6IiPczmONFE4hwDw=";
  };

  vendorHash = "sha256-eMPcla1XKfq+zBb633Zz4cn820FWuEaRrXQJ1TQ8Lkg=";

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  # N.B.: using the Makefile is intentional.
  # We pass "nixpkgs" for build.Date to avoid `gh --version` reporting a very old date.
  buildPhase = ''
    runHook preBuild
    make GO_LDFLAGS="-s -w -X github.com/cli/cli/v${lib.versions.major version}/internal/build.Date=nixpkgs" GH_VERSION=${version} bin/gh ${lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) "manpages"}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 bin/gh -t $out/bin
    wrapProgram $out/bin/gh \
      --set-default GH_TELEMETRY false
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installManPage share/man/*/*.[1-9]

    installShellCompletion --cmd gh \
      --bash <($out/bin/gh completion -s bash) \
      --fish <($out/bin/gh completion -s fish) \
      --zsh <($out/bin/gh completion -s zsh)
  ''
  + ''
    runHook postInstall
  '';

  # most tests require network access
  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = gh;
  };

  meta = {
    description = "GitHub CLI tool";
    homepage = "https://cli.github.com/";
    changelog = "https://github.com/cli/cli/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "gh";
    maintainers = with lib.maintainers; [
      mdaniels5757
      zowoq
      savtrip
    ];
  };
}
