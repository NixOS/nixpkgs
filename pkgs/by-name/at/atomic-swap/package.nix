{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  makeWrapper,
  monero-cli,
}:

let
  pname = "atomic-swap";
  version = "0.4.3";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "AthanorLabs";
    repo = "atomic-swap";
    rev = "v${version}";
    hash = "sha256-MOylUZ6BrvlxUrsZ5gg3JzW9ROG5UXeGhq3YoPZKdHs=";
  };

  vendorHash = "sha256-fGQ6MI+3z7wRL0y7AUERVtN0V2rcRa+vqeB8+3FMzzc=";

  subPackages = [
    "cmd/swapcli"
    "cmd/swapd"
    "cmd/bootnode"
  ];

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/swapd --prefix PATH : ${lib.makeBinPath [ monero-cli ]}
  '';

  # integration tests require network access
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/AthanorLabs/atomic-swap";
    changelog = "https://github.com/AthanorLabs/atomic-swap/releases/tag/v${version}";
    description = "ETH-XMR atomic swap implementation";
    license = with lib.licenses; [ lgpl3Only ];
    maintainers = with lib.maintainers; [
      happysalada
      lord-valen
    ];
  };
}
