{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  installShellFiles,
  python3,
}:

buildNpmPackage rec {
  pname = "balanceofsatoshis";
  version = "15.8.15";

  src = fetchFromGitHub {
    owner = "alexbosworth";
    repo = "balanceofsatoshis";
    rev = "v${version}";
    hash = "sha256-8GWITeFn7ELUH7bxcNlmQvgperQutBwVUhp2yjeEWrM=";
  };

  npmDepsHash = "sha256-lTXv4pEjrzcOK68RO1K007r7dCbAyc45G8Oy8V3XLts=";

  nativeBuildInputs = [
    installShellFiles
    python3
  ];

  dontNpmBuild = true;

  npmFlags = [ "--ignore-scripts" ];

  postInstall = ''
    installShellCompletion --cmd bos \
        --bash <($out/bin/bos completion bash) \
        --zsh <($out/bin/bos completion zsh) \
        --fish <($out/bin/bos completion fish)
  '';

  meta = {
    changelog = "https://github.com/alexbosworth/balanceofsatoshis/blob/${src.rev}/CHANGELOG.md";
    description = "Tool for working with the balance of your satoshis on LND";
    homepage = "https://github.com/alexbosworth/balanceofsatoshis";
    license = lib.licenses.mit;
    mainProgram = "bos";
    maintainers = with lib.maintainers; [ mmilata ];
  };
}
