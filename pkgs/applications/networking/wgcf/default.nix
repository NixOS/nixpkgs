{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "wgcf";
  version = "2.2.21";

  src = fetchFromGitHub {
    owner = "ViRb3";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-FzzPDTRmDCBS7EZOgj4ckytbtlRPqPdHpyn3nF0yHdc=";
  };

  subPackages = ".";

  vendorHash = "sha256-cGtm+rUgYppwwL/BizWikPUyFExHzLucL2o2g9PgGNw=";

  meta = with lib; {
    description = "Cross-platform, unofficial CLI for Cloudflare Warp";
    homepage = "https://github.com/ViRb3/wgcf";
    license = licenses.mit;
    maintainers = with maintainers; [ yureien ];
    mainProgram = "wgcf";
  };
}
