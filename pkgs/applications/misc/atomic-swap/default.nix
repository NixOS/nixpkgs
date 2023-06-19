{ lib, fetchFromGitHub, buildGoModule, makeWrapper, monero-cli }:
buildGoModule rec {
  pname = "atomic-swap";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "AthanorLabs";
    repo = "atomic-swap";
    rev = "v${version}";
    hash = "sha256-CYqYRYLMfvPX8TqyFSRg4ookeIfYGc0HDzu/Ip9Ecsg=";
  };

  vendorHash = "sha256-igHuklt76r7MDxz8TAaFgFdQS7L3DJkMYarAMNVYTC4=";

  subPackages = [ "cmd/swapcli" "cmd/swapd" ];
  tags = [ "prod" ];
  doCheck = false;

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/swapd --prefix PATH : ${lib.makeBinPath [ monero-cli ]}
  '';

  meta = with lib; {
    platforms = with platforms; all;
    mainProgram = "swapcli";
    description = "ETH-XMR atomic swap implementation";
    homepage = "https://github.com/AthanorLabs/atomic-swap";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ lord-valen ];
  };
}
