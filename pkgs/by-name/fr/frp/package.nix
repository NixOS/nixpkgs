{
  buildGoModule,
  callPackage,
  lib,
  fetchFromGitHub,
  nixosTests,
}:
let
  web = callPackage ./dashboard.nix { };
in
buildGoModule (finalAttrs: {
  pname = "frp";
  version = "0.71.1";
  src = fetchFromGitHub {
    owner = "fatedier";
    repo = "frp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-s+D8CL0wGfnl9xPHFQ0poIHaV55hpKHKOt/be27YJvA=";
  };

  vendorHash = "sha256-2JLUcSfvZjwTWPbvdJbhgi6eE9m4ep+75vLpF7ILrRQ=";

  doCheck = false;

  subPackages = [
    "cmd/frpc"
    "cmd/frps"
  ];

  preBuild = ''
    cp -r ${web.frpc} web/frpc/dist
    cp -r ${web.frps} web/frps/dist
  '';

  passthru = {
    tests.frp = nixosTests.frp;
    inherit web;
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
    maintainers = with lib.maintainers; [ epireyn ];
  };
})
