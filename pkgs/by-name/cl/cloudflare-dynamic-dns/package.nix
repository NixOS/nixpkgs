{
  lib,
  buildGoModule,
  cloudflare-dynamic-dns,
  fetchFromGitHub,
  testers,
}:
buildGoModule rec {
  pname = "cloudflare-dynamic-dns";
  version = "4.3.15";

  src = fetchFromGitHub {
    owner = "zebradil";
    repo = "cloudflare-dynamic-dns";
    tag = version;
    hash = "sha256-COGGHvl6MlRd3mdQYmkMAw6J+G+usC10LHtoFGqzaXQ=";
  };

  vendorHash = "sha256-l/V1L2tsSD1aVXdJf+Kx9fsZjYqBZ3XDgWiUN6l+nE4=";

  subPackages = ".";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
    "-X=main.commit=nixpkg-${version}"
    "-X=main.date=1970-01-01"
  ];

  env.CGO_ENABLED = 0;

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
