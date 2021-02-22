{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ticker";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "achannarasappa";
    repo = "ticker";
    rev = "v${version}";
    sha256 = "sha256-k4ahoaEI2HBoEcRQscpitp2tWsiWmSYaErnth99xOqw=";
  };

  vendorSha256 = "sha256-8Ew+K/uTFoBAhPQwebtjl6bJPiSEE3PaZCYZsQLOMkw=";

  # Tests require internet
  doCheck = false;

  meta = with lib; {
    description = "Terminal stock ticker with live updates and position tracking";
    homepage = "https://github.com/achannarasappa/ticker";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ siraben ];
  };
}
