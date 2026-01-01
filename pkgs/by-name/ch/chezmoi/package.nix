{
  lib,
  buildGo125Module,
  fetchFromGitHub,
  installShellFiles,
}:

buildGo125Module (finalAttrs: {
  pname = "chezmoi";
<<<<<<< HEAD
  version = "2.68.1";
=======
  version = "2.66.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "twpayne";
    repo = "chezmoi";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-VJGT6sQhrLHqTJOcLknHj/Wz04Pj2/CBUqI5R6xPdQ4=";
  };

  vendorHash = "sha256-yNEx2/Vw5kjC428SObBCQ+OI7XwLUicbCvCpmVkdOtQ=";
=======
    hash = "sha256-TYEVMxebA4dvWMmgx4bMv1UKO2YGH+D+lZuiAu8ZmI4=";
  };

  vendorHash = "sha256-g9bzsmLKJ7pCmTnO8N9Um1FDBvQA0mqw14fwGYMb/K0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [
    installShellFiles
  ];

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
    "-X main.builtBy=nixpkgs"
  ];

  doCheck = false;

  postInstall = ''
    installShellCompletion --bash --name chezmoi.bash completions/chezmoi-completion.bash
    installShellCompletion --fish completions/chezmoi.fish
    installShellCompletion --zsh completions/chezmoi.zsh
  '';

  meta = {
    description = "Manage your dotfiles across multiple machines, securely";
    homepage = "https://www.chezmoi.io/";
    changelog = "https://github.com/twpayne/chezmoi/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "chezmoi";
  };
})
