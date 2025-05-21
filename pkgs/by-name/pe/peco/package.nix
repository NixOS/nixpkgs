{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "peco";
  version = "0.5.11";

  subPackages = [ "cmd/peco" ];

  src = fetchFromGitHub {
    owner = "peco";
    repo = "peco";
    rev = "v${version}";
    sha256 = "sha256-OVUfeNpnmuJsgD//JTn6n9n4oOBxep69LhIpHX+ru2w=";
  };

  vendorHash = "sha256-+HQz7UUgATdgSWlI1dg2DdQRUSke9MyAtXgLikFhF90=";

  meta = with lib; {
    description = "Simplistic interactive filtering tool";
    mainProgram = "peco";
    homepage = "https://github.com/peco/peco";
    changelog = "https://github.com/peco/peco/blob/v${version}/Changes";
    license = licenses.mit;
    maintainers = with maintainers; [ pSub ];
  };
}
