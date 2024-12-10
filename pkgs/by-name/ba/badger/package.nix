{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "badger";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "dgraph-io";
    repo = "badger";
    rev = "v${version}";
    hash = "sha256-Kzhua1nF9Y0j6Ez35ucKdYMRR46yEwM0pJ8P6A7pUrw=";
  };

  vendorHash = "sha256-A9rMLWjCpM9VrXmWXNo/mZbGCBKrakxbjthVOl2aDa4=";

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
