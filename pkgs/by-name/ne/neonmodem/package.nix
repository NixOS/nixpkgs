{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  installShellFiles,
}:

buildGoModule rec {
  pname = "neonmodem";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "mrusme";
    repo = "neonmodem";
    tag = "v${version}";
    hash = "sha256-VLR6eicffA0IXVwEZMvgpm1kVmrLYVZOtq7MSy+vIw8=";
  };

  vendorHash = "sha256-pESNARoUgfg5/cTlTvKF3i7dTMIu0gRG/oV4Ov6h2cY=";

  passthru.updateScript = nix-update-script { };

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    # Will otherwise panic if it can't open $HOME/.cache/neonmodem.log
    # Upstream issue: https://github.com/mrusme/neonmodem/issues/53
    export XDG_CACHE_HOME="$(mktemp -d)"

    installShellCompletion --cmd neonmodem \
      --bash <($out/bin/neonmodem completion bash) \
      --fish <($out/bin/neonmodem completion fish) \
      --zsh <($out/bin/neonmodem completion zsh)
  '';

  meta = {
    description = "BBS-style TUI client for Discourse, Lemmy, Lobsters, and Hacker News";
    homepage = "https://neonmodem.com";
    downloadPage = "https://github.com/mrusme/neonmodem/releases";
    changelog = "https://github.com/mrusme/neonmodem/releases/tag/${src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ acuteaangle ];
    mainProgram = "neonmodem";
  };
}
