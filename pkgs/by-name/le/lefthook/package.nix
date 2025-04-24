{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

let
  pname = "lefthook";
  version = "1.11.10";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "evilmartians";
    repo = "lefthook";
    rev = "v${version}";
    hash = "sha256-WhveZtkwG2HbshT1xbA7wnhfxP6vmQ0h+rCxqgbwO5g=";
  };

  vendorHash = "sha256-aINRFg3TByOEjFgoPr33bDL6TFnlW/b9DqDTEJWNnGI=";

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
