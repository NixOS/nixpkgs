{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ticker";
  version = "3.1.9";

  src = fetchFromGitHub {
    owner = "achannarasappa";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/OpDcsRIwuj1bvtpPyk1Qc9QZGJMLiOLj8NBfbT7hdo=";
  };

  vendorSha256 = "sha256-aUBj7ZGWBeWc71y1CWm/KCw+El5TwH29S+KxyZGH1Zo=";

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
