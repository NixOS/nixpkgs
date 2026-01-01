{
  lib,
  buildGoModule,
  fetchFromGitHub,
<<<<<<< HEAD
  installShellFiles,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  nix-update-script,
}:

buildGoModule rec {
  pname = "fabric-ai";
<<<<<<< HEAD
  version = "1.4.364";
=======
  version = "1.4.334";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "danielmiessler";
    repo = "fabric";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-XOvvT13L2vOQiq0gYeWdRP/H+mu0BI47koG+DzvuAhg=";
  };

  vendorHash = "sha256-U7oVc7DiFWdnEfemSDtmo4XYJj/564qDOZzQX0AVOqc=";
=======
    hash = "sha256-O63UsnVufi6QYfl233vqFnoR5WW5ttLN5xdBJ7DxBso=";
  };

  vendorHash = "sha256-qWaMBhjt20WAIhDcjY4oOFBT+neJiXg0N2WsPasuHSU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # Fabric introduced plugin tests that fail in the nix build sandbox.
  doCheck = false;

  ldflags = [
    "-s"
    "-w"
  ];

<<<<<<< HEAD
  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion \
      --bash ./completions/fabric.bash \
      --zsh ./completions/_fabric \
      --fish ./completions/fabric.fish
  '';

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fabric is an open-source framework for augmenting humans using AI. It provides a modular framework for solving specific problems using a crowdsourced set of AI prompts that can be used anywhere";
    homepage = "https://github.com/danielmiessler/fabric";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jaredmontoya ];
    mainProgram = "fabric";
  };
}
