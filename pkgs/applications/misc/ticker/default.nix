{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ticker";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "achannarasappa";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-DdUXT8xrKd114U+CSwIgl7XczxQZGWVZA3tMU7461xY=";
  };

  vendorSha256 = "sha256-vTB1RPg1LN44bkWrdGEXR6WRlM/Q2EITUO0yt5ar/zg=";

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
