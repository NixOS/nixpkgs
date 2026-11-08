{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "certstrap";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "square";
    repo = "certstrap";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-5w79prxZrmB7KazOagmdJH9e5GM7iybQy8ttWxVNTMU=";
  };

  vendorHash = "sha256-wIEr8du0aQvcvQ4VXL6VdhtNUMo/bWVH32gaRQktSA0=";

  subPackages = [ "." ];

  ldflags = [ "-X main.release=${finalAttrs.version}" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

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
