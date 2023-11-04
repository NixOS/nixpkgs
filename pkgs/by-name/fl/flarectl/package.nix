{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "flarectl";
  version = "0.80.0";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "cloudflare-go";
    rev = "v${version}";
    hash = "sha256-Dks5tF+mHVmtj8Uh8eK50ZPZTW8p65Da08EHUnLfF7g=";
  };

  vendorHash = "sha256-gQxHJNPLVcnilMIv4drDCcQ8QJCyuZ6vejsuo0elIPw=";

  subPackages = ["cmd/flarectl"];

  meta = with lib; {
    description = "A CLI application for interacting with a Cloudflare account. (official)";
    homepage = "https://github.com/cloudflare/cloudflare-go";
    license = licenses.bsd3;
    maintainers = with maintainers; [ psibi ];
  };
}
