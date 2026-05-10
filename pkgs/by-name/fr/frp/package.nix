{
  buildGoModule,
  lib,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "frp";
  version = "0.66.0";

  src = fetchFromGitHub {
    owner = "fatedier";
    repo = "frp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GFvXdhX7kA43kppWWdL7KhummUCqpa1cQ7V2d9ISGfo=";
  };

  vendorHash = "sha256-m5ECF0cgp2LfsTKey02MHz5TfqfzOCT5cU5trUfrOjY=";

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
  };
})
