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
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "alebeck";
    repo = "boring";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WdohrSeq2N1zDQlYnwIMn1FF3IIb3zAiLSuOOf2GioU=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  subPackages = [ "cmd/boring" ];

  vendorHash = "sha256-yjqJ7G9n3c1ABLWynswzLP7B6bSwH1dIYKfVZqJX30g=";

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
