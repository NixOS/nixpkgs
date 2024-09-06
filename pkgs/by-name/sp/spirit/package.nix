{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "spirit";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "cashapp";
    repo = "spirit";
    rev = "v${version}-prerelease";
    hash = "sha256-e0Eu7BeOwZA8UKwonuuOde1idzaIMtprWya7nxgqyjs=";
  };

  vendorHash = "sha256-es1PGgLoE3DklnQziRjWmY7f6NNVd24L2JiuLkol6HI=";

  subPackages = [ "cmd/spirit" ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    homepage = "https://github.com/cashapp/spirit";
    description = "Online schema change tool for MySQL";
    license = licenses.asl20;
    maintainers = with maintainers; [ aaronjheng ];
    mainProgram = "spirit";
  };
}
