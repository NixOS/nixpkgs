{
  buildGoModule,
  lib,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "frp";
  version = "0.62.1";

  src = fetchFromGitHub {
    owner = "fatedier";
    repo = "frp";
    rev = "v${version}";
    hash = "sha256-es8xngdSLLQ3/S0xdFGW7Pa4BJISo51oWPl1GE+7tBo=";
  };

  vendorHash = "sha256-koeOCkqYy1TUYXp2I7M+BIjmQEJGXtizOnqJuvzhHJM=";

  doCheck = false;

  subPackages = [
    "cmd/frpc"
    "cmd/frps"
  ];

  passthru.tests = {
    frp = nixosTests.frp;
  };

  meta = with lib; {
    description = "Fast reverse proxy";
    longDescription = ''
      frp is a fast reverse proxy to help you expose a local server behind a
      NAT or firewall to the Internet. As of now, it supports TCP and UDP, as
      well as HTTP and HTTPS protocols, where requests can be forwarded to
      internal services by domain name. frp also has a P2P connect mode.
    '';
    homepage = "https://github.com/fatedier/frp";
    license = licenses.asl20;
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
