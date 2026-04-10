{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
}:
buildGoModule rec {
  pname = "git-pkgs";
  version = "0.15.2";

  src = fetchFromGitHub {
    owner = "git-pkgs";
    repo = "git-pkgs";
    tag = "v${version}";
    hash = "sha256-2vtzWzl9x6wd6XE0Z3a9Z/Ph9kschBwcTsNGC7JEFrA=";
  };

  vendorHash = "sha256-USEs7eL0gwrddZDiKUUejYEBEAzWxt62qBo9o5/7AKc=";

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
