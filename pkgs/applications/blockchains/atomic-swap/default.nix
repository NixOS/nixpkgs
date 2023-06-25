{ lib, buildGoModule, fetchFromGitHub, nix-update-script }:

let
  pname = "atomic-swap";
  version = "0.4.0";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "AthanorLabs";
    repo = "atomic-swap";
    rev = "v${version}";
    hash = "sha256-wVLufTC7WcRELhzebzLgIUvIWklEY+8/C41FluPkya0=";
  };

  vendorSha256 = "sha256-igHuklt76r7MDxz8TAaFgFdQS7L3DJkMYarAMNVYTC4=";

  subPackages = [
    "cmd/swapcli"
    "cmd/swapd"
    "cmd/bootnode"
  ];

  # integration tests require network access
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://github.com/AthanorLabs/atomic-swap";
    description = "ETH-XMR atomic swap implementation";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ happysalada ];
  };
}
