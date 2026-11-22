{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
}:
buildGoModule rec {
  pname = "git-pkgs";
  version = "0.22.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "git-pkgs";
    repo = "git-pkgs";
    tag = "v${version}";
    hash = "sha256-SmHJzPYqIZzVrLp5HpwbtZ0lVPobY5q8xsUyojhzvVo=";
  };

  vendorHash = "sha256-9yfNU+RB+EoHyLwgf1MPYIPXb2hhQlQCd0bXm0ZDF9I=";

  subPackages = [ "." ];

  ldflags = [
    "-X github.com/git-pkgs/git-pkgs/cmd.version=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postBuild = ''
    go run scripts/generate-man/main.go
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
