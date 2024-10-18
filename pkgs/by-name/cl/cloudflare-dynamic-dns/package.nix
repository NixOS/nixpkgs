{
  lib,
  buildGoModule,
  cloudflare-dynamic-dns,
  fetchFromGitHub,
  testers,
}:
buildGoModule rec {
  pname = "cloudflare-dynamic-dns";
  version = "4.3.5";

  src = fetchFromGitHub {
    owner = "zebradil";
    repo = "cloudflare-dynamic-dns";
    rev = "refs/tags/${version}";
    hash = "sha256-9WJeWWgI96+LjMFl7TkDc7udsLvi54eAN3Y9iv2e+F4=";
  };

  vendorHash = "sha256-KtTZcFYzJOH2qwoeHYfksXN7sDVV9ERCFVrrqzdh3M0=";

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
