{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "cloudrecon";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "g0ldencybersec";
    repo = "CloudRecon";
    rev = "refs/tags/v${version}";
    hash = "sha256-SslHkwoMelvszrQZvNX28EokBgwnPDBbTUBA9jdJPro=";
  };

  vendorHash = "sha256-hLEmRq7Iw0hHEAla0Ehwk1EfmpBv6ddBuYtq12XdhVc=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Tool to find assets from certificates";
    homepage = "https://github.com/g0ldencybersec/CloudRecon";
    changelog = "https://github.com/g0ldencybersec/CloudRecon/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "cloudrecon";
  };
}
