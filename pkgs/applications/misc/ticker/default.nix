{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ticker";
  version = "4.5.5";

  src = fetchFromGitHub {
    owner = "achannarasappa";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7FSyW71NWmWmBNQ5QUqMJ4x9WLXpm0kvvjdjzx1yk/M=";
  };

  vendorHash = "sha256-6bosJ2AlbLZ551tCNPmvNyyReFJG+iS3SYUFti2/CAw=";

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
