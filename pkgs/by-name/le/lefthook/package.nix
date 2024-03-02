{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

let
  pname = "lefthook";
  version = "1.6.4";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "evilmartians";
    repo = "lefthook";
    rev = "v${version}";
    hash = "sha256-j4ejDL0QRpRUoUYYjYAlju0A9mHwtmBTRFQVYrh+xvU=";
  };

  vendorHash = "sha256-FEicYJUyn+eT7IqoL4XqIsL6JhYJ8+2UOgc/PTMpuI4=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [ "-s" "-w" ];

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
    maintainers = with lib.maintainers; [ AndersonTorres ];
  };
}
