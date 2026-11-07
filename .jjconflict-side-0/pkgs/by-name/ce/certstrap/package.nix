{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "certstrap";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "square";
    repo = "certstrap";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-/KdlGm3rpvvJpQcwR2GiJkkdd0Pb7BP8VyKPtIRjh7M=";
  };

  vendorHash = "sha256-Xdq+Lp7IpwrbaPwlni1KT2KDKb9nsHIYSWJ/nDyqm94=";

  subPackages = [ "." ];

  ldflags = [ "-X main.release=${finalAttrs.version}" ];

  meta = {
    description = "Tools to bootstrap CAs, certificate requests, and signed certificates";
    mainProgram = "certstrap";
    longDescription = ''
      A simple certificate manager written in Go, to bootstrap your own
      certificate authority and public key infrastructure. Adapted from etcd-ca.
    '';
    homepage = "https://github.com/square/certstrap";
    changelog = "https://github.com/square/certstrap/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
