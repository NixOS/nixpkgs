{
  lib,
  buildGoModule,
  fetchFromGitHub,
  go-mockery_2,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "git-team";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "hekmekk";
    repo = "git-team";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+j5d1tImVHaTx63uzLdh2YNCFa1ErAVv4OMwxOutBQ4=";
  };

  vendorHash = "sha256-NTOUL1oE2IhgLyYYHwRCMW5yCxIRxUwqkfuhSSBXf6A=";

  nativeBuildInputs = [
    go-mockery_2
    installShellFiles
  ];

  preBuild = ''
    mockery --dir=src/ --all --keeptree
  '';

  postInstall = ''
    go run main.go --generate-man-page > git-team.1
    installManPage git-team.1

    installShellCompletion --cmd git-team \
      --bash <($out/bin/git-team completion bash) \
      --zsh <($out/bin/git-team completion zsh)
  '';

  meta = {
    description = "Command line interface for managing and enhancing git commit messages with co-authors";
    homepage = "https://github.com/hekmekk/git-team";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lockejan ];
    mainProgram = "git-team";
  };
})
