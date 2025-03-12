{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

let
  pname = "lefthook";
  version = "1.10.10";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "evilmartians";
    repo = "lefthook";
    rev = "v${version}";
    hash = "sha256-i/Ke3Zdn8nY0lorxr+eBodTd5Uze7hVaPU/xS1mwbvo=";
  };

  vendorHash = "sha256-uUnXIeJlZQwMEQLELnCySjFFm6QDeAq9oW4P+hFARn4=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
  ];

  doCheck = false;

  postInstall = ''
    installShellCompletion --cmd lefthook \
      --bash <($out/bin/lefthook completion bash) \
      --fish <($out/bin/lefthook completion fish) \
      --zsh <($out/bin/lefthook completion zsh)
  '';

  meta = {
    description = "Fast and powerful Git hooks manager for any type of projects";
    homepage = "https://github.com/evilmartians/lefthook";
    changelog = "https://github.com/evilmartians/lefthook/raw/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "lefthook";
    maintainers = with lib.maintainers; [ ];
  };
}
