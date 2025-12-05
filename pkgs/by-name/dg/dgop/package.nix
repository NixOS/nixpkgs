{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:

buildGoModule rec {
  pname = "dgop";
  version = "0.1.11";

  src = fetchFromGitHub {
    owner = "AvengeMedia";
    repo = "dgop";
    tag = "v${version}";
    hash = "sha256-QhzRn7pYN35IFpKjjxJAj3GPJECuC+VLhoGem3ezycc=";
  };

  vendorHash = "sha256-kO8b/eV5Vm/Fwzyzb0p8N9SkNlhkJLmEiPYmR2m5+po=";

  ldflags = [
    "-w"
    "-s"
    "-X main.Version=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    mv $out/bin/{cli,dgop}

    installShellCompletion --cmd dgop \
      --bash <($out/bin/dgop completion bash) \
      --fish <($out/bin/dgop completion fish) \
      --zsh <($out/bin/dgop completion zsh)
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "API & CLI for System & Process Monitoring";
    homepage = "https://github.com/AvengeMedia/dgop";
    changelog = "https://github.com/AvengeMedia/dgop/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ luckshiba ];
    mainProgram = "dgop";
    platforms = lib.platforms.unix;
  };
}
