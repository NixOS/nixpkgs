{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "bee";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "ethersphere";
    repo = "bee";
    rev = "v${version}";
    sha256 = "sha256-3Oy9RhgMPRFjUs3Dj8XUhAqoxx5BTi32OiK4Y8YEG2Q=";
  };

  vendorHash = "sha256-w5ZijaK8Adt1ZHPMmXqRWq0v0jdprRKRu03rePtZLXA=";

  subPackages = [ "cmd/bee" ];

  ldflags = [ "-s" "-w" ];

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

      Swarm is a system of peer-to-peer networked nodes that create a decentralised storage and communication service. The system is economically self-sustaining due to a built-in incentive system enforced through smart contracts on the Ethereum blockchain.

      Bee is a Swarm node implementation, written in Go.
    '';
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ attila-lendvai ];
  };
}
