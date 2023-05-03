{ lib, fetchFromGitHub, buildGoModule, installShellFiles, testers, gh }:

buildGoModule rec {
  pname = "gh";
  version = "2.28.0";

  src = fetchFromGitHub {
    owner = "cli";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-FceyGNQwA6SFg97FtX4ATlevpLzG/FPVSoKBznWIfC8=";
  };

  vendorHash = "sha256-iTPdOolvWINUSSYiPZAwn5ZF44x/x1tIWnKUHAn8ITA=";

  nativeBuildInputs = [ installShellFiles ];

  # upstream unsets these to handle cross but it breaks our build
  postPatch = ''
    substituteInPlace Makefile \
      --replace "GOOS= GOARCH= GOARM= GOFLAGS= CGO_ENABLED=" ""
  '';

  buildPhase = ''
    runHook preBuild
    make GO_LDFLAGS="-s -w" GH_VERSION=${version} bin/gh manpages
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 bin/gh -t $out/bin
    installManPage share/man/*/*.[1-9]

    installShellCompletion --cmd gh \
      --bash <($out/bin/gh completion -s bash) \
      --fish <($out/bin/gh completion -s fish) \
      --zsh <($out/bin/gh completion -s zsh)
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
    maintainers = with maintainers; [ zowoq ];
  };
}
