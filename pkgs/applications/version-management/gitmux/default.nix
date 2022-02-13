{ lib, buildGoModule, fetchFromGitHub }:

with lib;

buildGoModule rec {
  pname = "gitmux";
  version = "0.7.6";

  src = fetchFromGitHub {
    owner = "arl";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-y4G+uYT+7N/bGUDOPkMgy1amD6oBIgGQyhSAEb1kCQs";
  };

  vendorSha256 = "sha256-znoONkvLYBgH44MiyR7bZwvf7htNSTCAMfWT52gDO4Q=";

  ldflags = [ "-X main.version=${version}" ];

  proxyVendor = true;

  doCheck = false;

  meta = {
    description = "Gitmux shows git status in your tmux status bar";
    homepage = "https://github.com/arl/gitmux";
    license = licenses.mit;
    maintainers = with maintainers; [ qbit ];
  };
}
