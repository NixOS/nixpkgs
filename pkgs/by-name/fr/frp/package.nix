{
  buildGoModule,
  lib,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "frp";
  version = "0.65.0";

  src = fetchFromGitHub {
    owner = "fatedier";
    repo = "frp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-H7iFrp+XevT4+3b72EkBTJKMGSPGCmRbi56RQIOXaMg=";
  };

  vendorHash = "sha256-lwLBGVN9wQLT8J5EyGVf1gsC89GQms2NXh9YTfjYKhY=";

  doCheck = false;

  subPackages = [
    "cmd/frpc"
    "cmd/frps"
  ];

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
    maintainers = with lib.maintainers; [ Br1ght0ne ];
  };
})
