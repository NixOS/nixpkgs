{ lib, fetchFromGitHub, buildGoModule, go }:

buildGoModule rec {
  pname = "kubelogin";
  version = "0.0.32";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-pMen6ZL1S0xr5+h7gVBMG4XjlZUifIiqHvjKgg8AY5c=";
  };

  vendorHash = "sha256-pNOCagxOcxhELSWO1GfbxGmopYXIgKD00XdZdVgawrc=";

  ldflags = [
    "-X main.version=${version}"
    "-X main.goVersion=${lib.getVersion go}"
  ];

  meta = with lib; {
    description = "A Kubernetes credential plugin implementing Azure authentication";
    inherit (src.meta) homepage;
    license = licenses.mit;
    maintainers = with maintainers; [ yurrriq ];
  };
}
