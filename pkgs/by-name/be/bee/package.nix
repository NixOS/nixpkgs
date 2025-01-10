{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "bee";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "ethersphere";
    repo = "bee";
    rev = "v${version}";
    hash = "sha256-pl0zx1Vmu1pC1JSGrz1M72ObzckUT1HbtgKb8hV1RG8=";
  };

  vendorHash = "sha256-kxfdreEGRY9NHxpGwgvdeYBg0m+itEhy7ih1JSD2E44=";

  subPackages = [ "cmd/bee" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/ethersphere/bee/v2.version=${version}"
    "-X github.com/ethersphere/bee/v2/pkg/api.Version=5.2.0"
    "-X github.com/ethersphere/bee/v2/pkg/api.DebugVersion=4.1.1"
    "-X github.com/ethersphere/bee/v2/pkg/p2p/libp2p.reachabilityOverridePublic=false"
    "-X github.com/ethersphere/bee/v2/pkg/postage/listener.batchFactorOverridePublic=5"
  ];

  env.CGO_ENABLED = 0;

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
    maintainers = [ ];
  };
}
