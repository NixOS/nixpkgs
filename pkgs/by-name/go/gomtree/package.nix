{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gomtree";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "vbatts";
    repo = "go-mtree";
    rev = "v${version}";
    hash = "sha256-MDX16z4H1fyuV5atEsZHReJyvC+MRdeA54DORCFtpqI=";
  };

  vendorHash = null;

  # test fails with nix due to ro file system
  checkFlags = [ "-skip=^TestXattr$" ];

  subPackages = [ "cmd/gomtree" ];

  ldflags = [
    "-s"
    "-X main.Version=${version}"
  ];

  meta = with lib; {
    description = "File systems verification utility and library, in likeness of mtree(8)";
    changelog = "https://github.com/vbatts/go-mtree/releases/tag/v${version}";
    homepage = "https://github.com/vbatts/go-mtree";
    license = licenses.bsd3;
    maintainers = with maintainers; [ phanirithvij ];
    mainProgram = "gomtree";
  };
}
