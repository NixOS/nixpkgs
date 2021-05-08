{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ticker";
  version = "4.0.3";

  src = fetchFromGitHub {
    owner = "achannarasappa";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-YVpspFBwao/7M2nTVMw+ANc0roL0vBO4DpNUb7Thp3Q=";
  };

  vendorSha256 = "sha256-nidOIjrTL4llV5GORebXOOPGeL6TxkurDY82cIc7+mU=";

  preBuild = ''
    buildFlagsArray+=("-ldflags" "-s -w -X github.com/achannarasappa/ticker/cmd.Version=v${version}")
  '';

  # Tests require internet
  doCheck = false;

  meta = with lib; {
    description = "Terminal stock ticker with live updates and position tracking";
    homepage = "https://github.com/achannarasappa/ticker";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ siraben ];
  };
}
