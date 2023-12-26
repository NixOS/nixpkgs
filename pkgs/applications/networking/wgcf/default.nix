{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "wgcf";
  version = "2.2.20";

  src = fetchFromGitHub {
    owner = "ViRb3";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-k4oOejJiVZk9s4niG/r0mSoI363uuQh3C9OWVweELWc=";
  };

  subPackages = ".";

  vendorHash = "sha256-U1VHbD2l5C5ws7Mt5a7PmtHQkZJ6hzDU1TyiEFqMYEM=";

  meta = with lib; {
    description = "Cross-platform, unofficial CLI for Cloudflare Warp";
    homepage = "https://github.com/ViRb3/wgcf";
    license = licenses.mit;
    maintainers = with maintainers; [ yureien ];
    mainProgram = "wgcf";
  };
}
