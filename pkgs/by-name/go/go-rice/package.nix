{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "go-rice";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "GeertJohan";
    repo = "go.rice";
    rev = "v${version}";
    sha256 = "sha256-jO4otde/m52L2NrE88aXRjdGDBNxnbP1Zt+5fEqfNIc=";
  };

  vendorHash = "sha256-VlpdZcqg7yWUADN8oD/IAgAXVdzJeIeymx2Pu/7E21o=";

  subPackages = [
    "."
    "rice"
  ];

  meta = with lib; {
    description = "Go package that makes working with resources such as html, js, css, images, templates very easy";
    homepage = "https://github.com/GeertJohan/go.rice";
    license = licenses.bsd2;
    maintainers = with maintainers; [ blaggacao ];
    mainProgram = "rice";
  };
}
