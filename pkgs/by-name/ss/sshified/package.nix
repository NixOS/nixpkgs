{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "sshified";
  version = "1.2.7";

  src = fetchFromGitHub {
    owner = "hoffie";
    repo = "sshified";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yeG0LqgRknAnN4rLV/659YJpxk3hBxDKX1BIioJ9P2M=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${finalAttrs.version}"
  ];

  subPackages = [ "." ];

  meta = {
    description = "Proxy HTTP requests through SSH";
    homepage = "https://github.com/hoffie/sshified";
    changelog = "https://github.com/hoffie/sshified/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ joinemm ];
    mainProgram = "sshified";
  };
})
