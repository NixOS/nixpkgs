{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "sshified";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "hoffie";
    repo = "sshified";
    tag = "v${version}";
    hash = "sha256-+YaqHkcsP6+J39w4WP5iA0LowmGwDHBoDNzT8fhv+Xg=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${version}"
  ];

  subPackages = [ "." ];

  meta = {
    description = "Proxy HTTP requests through SSH";
    homepage = "https://github.com/hoffie/sshified";
    changelog = "https://github.com/hoffie/sshified/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ joinemm ];
    mainProgram = "sshified";
  };
}
