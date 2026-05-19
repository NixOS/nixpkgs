{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "proxyt";
  version = "0.0.6";

  src = fetchFromGitHub {
    owner = "jaxxstorm";
    repo = "proxyt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FnTem3EZSEOeG7mh4HgzTl757jgfc7qXPk9YvxVlgKU=";
  };

  vendorHash = "sha256-wdbfcYS3A0c/XDnMxyBOx4pFdMk3FOYQlwTmbS/zMj4=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/jaxxstorm/proxyt/cmd.Version=${finalAttrs.version}"
  ];

  __structuredAttrs = true;

  env = {
    CGO_ENABLED = "0";
  };

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd proxyt \
      --bash <($out/bin/proxyt completion bash) \
      --fish <($out/bin/proxyt completion fish) \
      --zsh <($out/bin/proxyt completion zsh)
  '';

  meta = {
    description = "Simple proxy for the Tailscale control plane";
    homepage = "https://github.com/jaxxstorm/proxyt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ marie ];
    mainProgram = "proxyt";
  };
})
