{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "fabric-ai";
  version = "1.4.400";

  src = fetchFromGitHub {
    owner = "danielmiessler";
    repo = "fabric";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pkB11lNOxpu9n5keG4m+veyiH+CCq4Myc3IqnA9MZg8=";
  };

  vendorHash = "sha256-kL1aCWNEgacKiYQf8LJYxCqmzlAgHi1ulcjrMOw513U=";

  # Fabric introduced plugin tests that fail in the nix build sandbox.
  doCheck = false;

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion \
      --bash ./completions/fabric.bash \
      --zsh ./completions/_fabric \
      --fish ./completions/fabric.fish
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fabric is an open-source framework for augmenting humans using AI. It provides a modular framework for solving specific problems using a crowdsourced set of AI prompts that can be used anywhere";
    homepage = "https://github.com/danielmiessler/fabric";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jaredmontoya ];
    mainProgram = "fabric";
  };
})
