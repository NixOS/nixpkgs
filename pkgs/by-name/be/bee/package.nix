{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "bee";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "ethersphere";
    repo = "bee";
    rev = "v${finalAttrs.version}";
    hash = "sha256-SteqSo2mfb3Mr5Zn1fZauhQbQ8iE3VgoDfLVj/IDhvs=";
  };

  vendorHash = "sha256-6yX2WnWH2K7/2Ou82mw7/LJfu5MEZp/MN61Z2N5pgPc=";

  subPackages = [ "cmd/bee" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/ethersphere/bee/v2.version=${finalAttrs.version}"
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

  meta = {
    homepage = "https://github.com/ethersphere/bee";
    description = "Ethereum Swarm Bee";
    longDescription = ''
      A decentralised storage and communication system for a sovereign digital society.

      Swarm is a system of peer-to-peer networked nodes that create a decentralised storage
      and communication service. The system is economically self-sustaining due to a built-in
      incentive system enforced through smart contracts on the Ethereum blockchain.

      Bee is a Swarm node implementation, written in Go.
    '';
    license = with lib.licenses; [ bsd3 ];
    maintainers = [ ];
  };
})
