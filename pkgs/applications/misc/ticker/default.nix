{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ticker";
  version = "3.1.7";

  src = fetchFromGitHub {
    owner = "achannarasappa";
    repo = "ticker";
    rev = "v${version}";
    sha256 = "sha256-OA01GYp6E0zsEwkUUtvpmvl0y/YTXChl0pwIKozB4Qg=";
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
