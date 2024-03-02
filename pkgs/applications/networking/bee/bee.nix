{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "bee";
  version = "1.18.2";

  src = fetchFromGitHub {
    owner = "ethersphere";
    repo = "bee";
    rev = "v${version}";
    sha256 = "sha256-LUOKF1073GmQWG2q4w0cTErSHw7ok5N6PQZ45xpjYx4=";
  };

  vendorHash = "sha256-UdsF/otjXqS1NY3PkCimRiD93hGntHG3Xhw6avFtHog=";

  subPackages = [ "cmd/bee" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/ethersphere/bee.version=${version}"
    "-X github.com/ethersphere/bee/pkg/api.Version=5.2.0"
    "-X github.com/ethersphere/bee/pkg/api.DebugVersion=4.1.0"
    "-X github.com/ethersphere/bee/pkg/p2p/libp2p.reachabilityOverridePublic=false"
    "-X github.com/ethersphere/bee/pkg/postage/listener.batchFactorOverridePublic=5"
  ];

  CGO_ENABLED = 0;

  postInstall = ''
    mkdir -p $out/lib/systemd/system
    cp packaging/bee.service $out/lib/systemd/system/
    cp packaging/bee-get-addr $out/bin/
    chmod +x $out/bin/bee-get-addr
    patchShebangs $out/bin/
  '';

  meta = with lib; {
    homepage = "https://github.com/ethersphere/bee";
    description = "Ethereum Swarm Bee";
    longDescription = ''
      A decentralised storage and communication system for a sovereign digital society.

      Swarm is a system of peer-to-peer networked nodes that create a decentralised storage
      and communication service. The system is economically self-sustaining due to a built-in
      incentive system enforced through smart contracts on the Ethereum blockchain.

      Bee is a Swarm node implementation, written in Go.
    '';
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ ];
  };
}
