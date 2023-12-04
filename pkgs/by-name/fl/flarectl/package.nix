{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "flarectl";
  version = "0.82.0";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "cloudflare-go";
    rev = "v${version}";
    hash = "sha256-GWxtbPCo0t0HXCiLJEVtuJPiY8Ahlij8zaMwe67zjqU=";
  };

  vendorHash = "sha256-VGePv/RzX1t5+Ftp3iTKYxm3mN6rr+Kdav4jRIKim9E=";

  subPackages = [ "cmd/flarectl" ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "CLI application for interacting with a Cloudflare account";
    homepage = "https://github.com/cloudflare/cloudflare-go";
    changelog = "https://github.com/cloudflare/cloudflare-go/blob/${src.rev}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jmbaur ];
    mainProgram = "flarectl";
  };
}
