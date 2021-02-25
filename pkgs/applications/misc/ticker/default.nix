{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ticker";
  version = "3.1.8";

  src = fetchFromGitHub {
    owner = "achannarasappa";
    repo = "ticker";
    rev = "v${version}";
    sha256 = "sha256-U2TYUB4RHUBPoXe/te+QpXglbVcrT6SItiDrA7ODX6w=";
  };

  vendorSha256 = "sha256-aUBj7ZGWBeWc71y1CWm/KCw+El5TwH29S+KxyZGH1Zo=";

  # Tests require internet
  doCheck = false;

  meta = with lib; {
    description = "Terminal stock ticker with live updates and position tracking";
    homepage = "https://github.com/achannarasappa/ticker";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ siraben ];
  };
}
