{
  buildGoModule,
  lib,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "frp";
  version = "0.63.0";

  src = fetchFromGitHub {
    owner = "fatedier";
    repo = "frp";
    rev = "v${version}";
    hash = "sha256-xTR273szc1UWTaZ+kT6+Vur/EE2YxfF8gnUQwNz/dxY=";
  };

  vendorHash = "sha256-MNGn/ES+gfSFPTz/EeefmFlICg0e5fAMOBPB/jt4CDM=";

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
