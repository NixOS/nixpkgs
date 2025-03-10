{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  installShellFiles,
  python3,
}:

buildNpmPackage rec {
  pname = "balanceofsatoshis";
  version = "19.4.10";

  src = fetchFromGitHub {
    owner = "alexbosworth";
    repo = "balanceofsatoshis";
    rev = "v${version}";
    hash = "sha256-WJuxe3k8ZLlkB5SpvE1DSyxQsc5bYEKVsM8tt5vdYOU=";
  };

  npmDepsHash = "sha256-dsWYUCPbiF/L3RcdcaWVn6TnU1/XMy9l7eQgHrBYW4o=";

  nativeBuildInputs = [
    installShellFiles
    python3
  ];

  dontNpmBuild = true;

  npmFlags = [ "--ignore-scripts" ];

  # Completion changed since v19
  # https://github.com/alexbosworth/balanceofsatoshis?tab=readme-ov-file#usage
  #postInstall = ''
  #  installShellCompletion --cmd bos \
  #      --bash <($out/bin/bos completion bash) \
  #      --zsh <($out/bin/bos completion zsh) \
  #      --fish <($out/bin/bos completion fish)
  #'';

  meta = {
    changelog = "https://github.com/alexbosworth/balanceofsatoshis/blob/${src.rev}/CHANGELOG.md";
    description = "Tool for working with the balance of your satoshis on LND";
    homepage = "https://github.com/alexbosworth/balanceofsatoshis";
    license = lib.licenses.mit;
    mainProgram = "bos";
    maintainers = with lib.maintainers; [ mmilata mariaa144 ];
  };
}
