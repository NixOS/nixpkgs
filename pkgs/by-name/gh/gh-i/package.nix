{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gh-i";
  version = "0.0.10";

  src = fetchFromGitHub {
    owner = "gennaro-tedesco";
    repo = "gh-i";
    rev = "v${version}";
    hash = "sha256-k1xfQxRh8T0SINtbFlIVNFEODYU0RhBAkjudOv1bLvw=";
  };

  vendorHash = "sha256-eqSAwHFrvBxLl5zcZyp3+1wTf7+JmpogFBDuVgzNm+w=";

  ldflags = [ "-s" ];

  meta = with lib; {
    description = "Search github issues interactively";
    changelog = "https://github.com/gennaro-tedesco/gh-i/releases/tag/v${version}";
    homepage = "https://github.com/gennaro-tedesco/gh-i";
    license = licenses.asl20;
    maintainers = with maintainers; [ phanirithvij ];
    mainProgram = "gh-i";
  };
}
