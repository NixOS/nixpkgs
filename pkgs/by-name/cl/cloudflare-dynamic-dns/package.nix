{
  lib,
  buildGoModule,
  cloudflare-dynamic-dns,
  fetchFromGitHub,
  testers,
}:
buildGoModule rec {
  pname = "cloudflare-dynamic-dns";
  version = "4.3.2";

  src = fetchFromGitHub {
    owner = "zebradil";
    repo = "cloudflare-dynamic-dns";
    rev = "refs/tags/${version}";
    hash = "sha256-SuDiR/saqxgfnEku31tjAtahWNg+5wFriD0F2FPkEEo=";
  };

  vendorHash = "sha256-vHlBZOeJ0oZZ4zjy4UycbdiMGzEpGRqT7v3q0hDz28M=";

  subPackages = ".";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
    "-X=main.commit=nixpkg-${version}"
    "-X=main.date=1970-01-01"
  ];

  CGO_ENABLED = 0;

  passthru.tests.version = testers.testVersion { package = cloudflare-dynamic-dns; };

  meta = with lib; {
    changelog = "https://github.com/Zebradil/cloudflare-dynamic-dns/blob/${version}/CHANGELOG.md";
    description = "Dynamic DNS client for Cloudflare";
    homepage = "https://github.com/Zebradil/cloudflare-dynamic-dns";
    license = licenses.mit;
    mainProgram = "cloudflare-dynamic-dns";
    maintainers = [ maintainers.zebradil ];
  };
}
