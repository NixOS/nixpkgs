{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

let
  pname = "lefthook";
  version = "1.6.15";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "evilmartians";
    repo = "lefthook";
    rev = "v${version}";
    hash = "sha256-Pc4m4T/+hABX3eGgni12EC8lD9xl5j/eALhfuSVbEJc=";
  };

  vendorHash = "sha256-ralnfqrP6R58Wjc/AWRf1motWZICPagZxHCkqVcwYoo=";

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
