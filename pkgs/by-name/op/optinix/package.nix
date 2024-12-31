{
  lib,
  fetchFromGitLab,
  buildGoModule,
  installShellFiles,
}:
buildGoModule rec {
  pname = "optinix";
  version = "0.1.1";

  src = fetchFromGitLab {
    owner = "hmajid2301";
    repo = "optinix";
    rev = "v${version}";
    hash = "sha256-bRHesc03jExIL29BCP93cMbx+BOT4sHCu58JjpmRaeA=";
  };

  vendorHash = "sha256-uSFEhRWvJ83RGpekPJL9MOYJy2NfgVdZxuaNUMq3VaE=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd optinix \
      --bash <($out/bin/optinix completion bash) \
      --fish <($out/bin/optinix completion fish) \
      --zsh <($out/bin/optinix completion zsh)
  '';

  meta = {
    description = "Tool for searching options in Nix";
    homepage = "https://gitlab.com/hmajid2301/optinix";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hmajid2301 ];
    mainProgram = "optinix";
  };
}
