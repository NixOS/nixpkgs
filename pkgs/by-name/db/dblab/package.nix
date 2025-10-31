{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "dblab";
  version = "0.34.2";

  src = fetchFromGitHub {
    owner = "danvergara";
    repo = "dblab";
    rev = "v${version}";
    hash = "sha256-e3p2+QBoxyJu15fTb/7gH32zE4h8V2iDxbxoNMVqElM=";
  };

  vendorHash = "sha256-NhBT0dBS3jKgWHxCMVV6NUMcvqCbKS+tlm3y1YI/sAE=";

  ldflags = [ "-s -w -X main.version=${version}" ];

  # some tests require network access
  doCheck = false;

  meta = with lib; {
    description = "Database client every command line junkie deserves";
    homepage = "https://github.com/danvergara/dblab";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
  };
}
