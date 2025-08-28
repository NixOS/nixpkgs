{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "optnix";
  version = "0.2.0";
  src = fetchFromGitHub {
    owner = "water-sucks";
    repo = "optnix";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CI0D70oP4usQXh39wm2z+s9QKQaaHFB6og3B/VHaAiY=";
  };

  vendorHash = "sha256-/rV21mX6VrJj39M6dBw4ubp6+O47hxeLn0ZcsG6Ujno=";

  nativeBuildInputs = [ installShellFiles ];

  env = {
    CGO_ENABLED = 0;
    VERSION = finalAttrs.version;
  };

  buildPhase = ''
    runHook preBuild
    make all
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 ./optnix -t $out/bin

    runHook postInstall
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd optnix \
      --bash <($out/bin/optnix --completion bash) \
      --fish <($out/bin/optnix --completion fish) \
      --zsh <($out/bin/optnix --completion zsh)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/water-sucks/optnix";
    description = "Options searcher for Nix module systems";
    changelog = "https://github.com/water-sucks/optnix/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ water-sucks ];
    mainProgram = "optnix";
  };
})
