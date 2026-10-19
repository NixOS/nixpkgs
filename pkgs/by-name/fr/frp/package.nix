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
  version = "0.72.0";
  src = fetchFromGitHub {
    owner = "fatedier";
    repo = "frp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5uN65zB8Gj4IL/o+DGrXfWgy0W90pr8i73iQqEsUcs0=";
  };

  vendorHash = "sha256-+ron+/WjoiTZrsrfZ0GkRFtYphvFGI0hIfkxMhKursk=";

  doCheck = false;

  patches = [
    # stopgap solution for CVE-2026-110619
    ./apply-middleware-pprof-path.patch
  ];

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
