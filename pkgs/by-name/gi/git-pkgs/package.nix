{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
}:
buildGoModule rec {
  pname = "git-pkgs";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "git-pkgs";
    repo = "git-pkgs";
    tag = "v${version}";
    hash = "sha256-XjW3qwybTmzW2CNgu1Edgs5ZZ9xl3+uS4sT8VWD3jyQ=";
  };

  vendorHash = "sha256-/LJwq17f7SAjSV2ZcLrdaKZYf9RVJ9wtYqEsW0ubT1Q=";

  subPackages = [ "." ];

  ldflags = [
    "-X github.com/git-pkgs/git-pkgs/cmd.version=${version}"
  ];

  # Tries to access the internet.
  doCheck = false;

  nativeBuildInputs = [ installShellFiles ];

  postBuild = ''
    go run scripts/generate-man.go
    installManPage man/*.1
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd git-pkgs \
      --bash <($out/bin/git-pkgs completion bash) \
      --fish <($out/bin/git-pkgs completion fish) \
      --zsh <($out/bin/git-pkgs completion zsh)
  '';

  meta = {
    homepage = "https://github.com/git-pkgs/git-pkgs";
    description = "Git subcommand for analyzing package/dependency usage in git repositories over time";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bnjmnt4n ];
    platforms = lib.platforms.unix;
    mainProgram = "git-pkgs";
  };
}
