{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ticker";
  version = "4.5.2";

  src = fetchFromGitHub {
    owner = "achannarasappa";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-9Gy7G/uRFUBfXlUa6nIle1WIS5Yf9DJMM57hE0oEyLI=";
  };

  vendorSha256 = "sha256-6bosJ2AlbLZ551tCNPmvNyyReFJG+iS3SYUFti2/CAw=";

  ldflags = [
    "-s" "-w" "-X github.com/achannarasappa/ticker/cmd.Version=v${version}"
  ];

  # Tests require internet
  doCheck = false;

  meta = with lib; {
    description = "Terminal stock ticker with live updates and position tracking";
    homepage = "https://github.com/achannarasappa/ticker";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ siraben ];
  };
}
