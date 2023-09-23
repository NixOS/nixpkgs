{ lib, buildGoModule, fetchFromGitHub, nix-update-script, makeWrapper, monero-cli }:
let
  pname = "atomic-swap";
  version = "0.4.2";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "AthanorLabs";
    repo = "atomic-swap";
    rev = "v${version}";
    hash = "sha256-JnbKaGmpTDwQMSDR4Y8Q2JTtuQV5GGuovxeIYs0KgQI=";
  };

  vendorHash = "sha256-acBnXGy1kVBwB+j8VqGyinabnI/boTtbFNyjE6EHVes=";

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

  meta = with lib; {
    homepage = "https://github.com/AthanorLabs/atomic-swap";
    description = "ETH-XMR atomic swap implementation";
    license = with licenses; [ lgpl3Only ];
    maintainers = with maintainers; [ happysalada lord-valen ];
  };
}
