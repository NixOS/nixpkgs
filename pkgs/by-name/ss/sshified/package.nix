{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "sshified";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "hoffie";
    repo = "sshified";
    tag = "v${version}";
    hash = "sha256-oCeuQ4Do+Lyqsf8hBH9qvLxWbWQlqol481VrbnAW2ic=";
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
