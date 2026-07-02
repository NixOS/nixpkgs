{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
}:

buildGoModule (finalAttrs: {
  pname = "sonoscli";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "steipete";
    repo = "sonoscli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9ouRJ0Rr+W5Kx9BltgW29Jo1Jq7Hb/un4XBkq+0in9o=";
  };

  vendorHash = "sha256-hocnLCzWN8srQcO3BMNkd2lt0m54Qe7sqAhUxVZlz1k=";

  subPackages = [ "cmd/sonos" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd sonos \
      --bash <($out/bin/sonos completion bash) \
      --fish <($out/bin/sonos completion fish) \
      --zsh  <($out/bin/sonos completion zsh)
  '';

  __structuredAttrs = true;

  meta = {
    description = "Control Sonos speakers from your terminal over LAN (UPnP/SOAP)";
    longDescription = ''
      sonoscli is a modern Go CLI to control Sonos speakers over your local
      network using UPnP/SOAP. Features include reliable SSDP discovery,
      coordinator-aware playback controls, grouping, queue management,
      favorites, scenes, Spotify integration via SMAPI, and live event watching.
    '';
    homepage = "https://github.com/steipete/sonoscli";
    changelog = "https://github.com/steipete/sonoscli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "sonos";
    maintainers = with lib.maintainers; [ j10ccc ];
    platforms = lib.platforms.unix;
  };
})
