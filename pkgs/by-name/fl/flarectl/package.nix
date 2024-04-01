{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "flarectl";
  version = "0.92.0";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "cloudflare-go";
    rev = "v${version}";
    hash = "sha256-nmDW8ALhyp5McnX86JN51kJSo0bUvwTsHnQkfKSxJMM=";
  };

  vendorHash = "sha256-F1fwzzBg60E7B9iPV0gziGB3WE1tcZ/6nMpnEyTjV1g=";

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
