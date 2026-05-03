{
  buildGoModule,
  callPackage,
  lib,
  fetchFromGitHub,
  nixosTests,
}:
let
  version = "0.68.1";

  src = fetchFromGitHub {
    owner = "fatedier";
    repo = "frp";
    tag = "v${version}";
    hash = "sha256-AF0SrJFqWzwYJZSRm36fl+nR3TO6GldUMko18AkhjLI=";
  };
  web = callPackage ./dashboard.nix { inherit version src; };
in
buildGoModule (finalAttrs: {
  pname = "frp";
  inherit version src;

  vendorHash = "sha256-Tolhk0si85L/ZRs5k+xt5H6bZceZaW7xMPvcunHufSU=";

  doCheck = false;

  subPackages = [
    "cmd/frpc"
    "cmd/frps"
  ];

  preBuild = ''
    cp -r ${web.frpc} web/frpc/dist
    cp -r ${web.frps} web/frps/dist
  '';

  passthru.tests = {
    frp = nixosTests.frp;
  };

  meta = {
    description = "Fast reverse proxy";
    longDescription = ''
      frp is a fast reverse proxy to help you expose a local server behind a
      NAT or firewall to the Internet. As of now, it supports TCP and UDP, as
      well as HTTP and HTTPS protocols, where requests can be forwarded to
      internal services by domain name. frp also has a P2P connect mode.
    '';
    homepage = "https://github.com/fatedier/frp";
    license = lib.licenses.asl20;
  };
})
