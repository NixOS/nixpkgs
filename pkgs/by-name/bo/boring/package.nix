{
  boring,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
  stdenv,
  nix-update-script,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "boring";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "alebeck";
    repo = "boring";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ljx2EtDN3UcyNfrnLH3RGKvyB+SQRLGLhYrbFJYIHtY=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  subPackages = [ "cmd/boring" ];

  vendorHash = "sha256-xMRax6+bXjdWdqF4k3yV4CpXlaYyZ/BL6qIMnEp8n1k=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/alebeck/boring/internal/buildinfo.Version=${finalAttrs.version}"
    "-X github.com/alebeck/boring/internal/buildinfo.Commit=${
      builtins.substring 0 5 finalAttrs.src.rev
    }"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd boring      \
      --bash <($out/bin/boring --shell bash) \
      --fish <($out/bin/boring --shell fish) \
      --zsh  <($out/bin/boring --shell zsh)
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = boring;
      command = "boring version";
      version = "boring ${finalAttrs.version}";
    };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "SSH tunnel manager";
    homepage = "https://github.com/alebeck/boring";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      jacobkoziej
    ];
    mainProgram = "boring";
  };
})
