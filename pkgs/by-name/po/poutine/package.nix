{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:
buildGoModule rec {
  pname = "poutine";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "boostsecurityio";
    repo = "poutine";
    rev = "v${version}";
    hash = "sha256-T81Qi79VaZzfKL4niTZQW+gwwiBcyInALrvyUg1V4Ck=";
  };

  nativeBuildInputs = [ installShellFiles ];

  vendorHash = "sha256-/chq40j+puAI3KdI15vbZwrnzCKrU7g+Z/t9aOXQ1Sg=";

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    installShellCompletion --cmd ${meta.mainProgram} \
      --bash <($out/bin/${meta.mainProgram} completions bash) \
      --fish <($out/bin/${meta.mainProgram} completions fish) \
      --zsh <($out/bin/${meta.mainProgram} completions zsh)
  '';

  meta = {
    description = "A security scanner that detects misconfigurations and vulnerabilities in the build pipelines of a repository.";
    homepage = "https://github.com/boostsecurityio/poutine";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dannixon ];
    mainProgram = "poutine";
  };
}
