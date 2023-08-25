{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "wgcf";
  version = "2.2.18";

  src = fetchFromGitHub {
    owner = "ViRb3";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-MTh92TlMQeIMmysQLcdsz45JHGJdOyR4oABjJUPobfE=";
  };

  subPackages = ".";

  vendorHash = "sha256-4VOjxGboYO00tJ17LNAYXiKQVUSUoveEYG/L+idYY6s=";

  meta = with lib; {
    description = "Cross-platform, unofficial CLI for Cloudflare Warp";
    homepage = "https://github.com/ViRb3/wgcf";
    license = licenses.mit;
    maintainers = with maintainers; [ yureien ];
  };
}
