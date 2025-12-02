{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "badger";
  version = "4.8.0";

  src = fetchFromGitHub {
    owner = "dgraph-io";
    repo = "badger";
    rev = "v${version}";
    hash = "sha256-LkJp0ixEJcD0mGeafjFoxjekeyep2nbZPXgVcMEofAU=";
  };

  vendorHash = "sha256-I7N85gdf4Bm/0zTcdFfbpah9veSpOzZcTvd7Ku5Xqpg=";

  subPackages = [ "badger" ];

  doCheck = false;

  meta = with lib; {
    description = "Fast key-value DB in Go";
    homepage = "https://github.com/dgraph-io/badger";
    license = licenses.asl20;
    mainProgram = "badger";
    maintainers = with maintainers; [ farcaller ];
  };
}
