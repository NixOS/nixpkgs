{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
let
  version = "0.7.3";
in
buildGoModule {
  pname = "lazyjournal";
  inherit version;

  src = fetchFromGitHub {
    owner = "Lifailon";
    repo = "lazyjournal";
    tag = version;
    hash = "sha256-uu36MmBT2K7ToeWcOxR/7ZvEVw+a3nj/zeA1ZbLTbYE=";
  };

  vendorHash = "sha256-1tQ0ZFww9VCnoRzmOQw9RaiRJmTRErAio13uAAKtgTw=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "TUI for journalctl, file system logs, as well as Docker and Podman containers";
    homepage = "https://github.com/Lifailon/lazyjournal";
    license = with lib.licenses; [ mit ];
    platforms = with lib.platforms; unix ++ windows;
    maintainers = with lib.maintainers; [ pluiedev ];
    mainProgram = "lazyjournal";
  };
}
