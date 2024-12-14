{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "chisel";
  version = "1.10.1";

  src = fetchFromGitHub {
    owner = "jpillora";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-b3r4D/P7D3kfIyMd1s/ntciY04qMrvSTru9+HjAOrnA=";
  };

  vendorHash = "sha256-+11Pd/QCxoLLkeazmU9/vnPBaB2MZXmx4cEZRDnyRcQ=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/jpillora/chisel/share.BuildVersion=${version}"
  ];

  # Tests require access to the network
  doCheck = false;

  meta = with lib; {
    description = "TCP/UDP tunnel over HTTP";
    longDescription = ''
      Chisel is a fast TCP/UDP tunnel, transported over HTTP, secured via
      SSH. Single executable including both client and server. Chisel is
      mainly useful for passing through firewalls, though it can also be
      used to provide a secure endpoint into your network.
    '';
    homepage = "https://github.com/jpillora/chisel";
    changelog = "https://github.com/jpillora/chisel/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
