{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

let
  pname = "lefthook";
  version = "1.5.2";
in
buildGoModule rec {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "evilmartians";
    repo = "lefthook";
    rev = "v${version}";
    hash = "sha256-9lAgKHcUAhg3Z8fMNYu3JrjfSd0HaT7YhvjKlpLMi0E=";
  };

  vendorHash = "sha256-/VLS7+nPERjIU7V2CzqXH69Z3/y+GKZbAFn+KcRKRuA=";

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
