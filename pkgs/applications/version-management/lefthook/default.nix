{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "lefthook";
  version = "1.3.3";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "evilmartians";
    repo = "lefthook";
    sha256 = "sha256-9XmLQPkc8we5wRZe5+bhL1b9lxWX6JAQeF4DmRXBgew=";
  };

  vendorHash = "sha256-VeR/lyrQrjXWvHdxpG4H+XPlAud9rrlzX8GqhVzn1sg=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [ "-s" "-w" ];

  doCheck = false;

  postInstall = ''
    installShellCompletion --cmd lefthook \
      --bash <($out/bin/lefthook completion bash) \
      --fish <($out/bin/lefthook completion fish) \
      --zsh <($out/bin/lefthook completion zsh)
  '';

  meta = with lib; {
    description = "Fast and powerful Git hooks manager for any type of projects";
    homepage = "https://github.com/evilmartians/lefthook";
    changelog = "https://github.com/evilmartians/lefthook/raw/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ rencire ];
  };
}
