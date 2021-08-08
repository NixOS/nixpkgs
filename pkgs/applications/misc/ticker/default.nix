{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ticker";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "achannarasappa";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-FavbBGmChWQ3xySPHlw5HisZwVaNe/NaxA6+InN8fL8=";
  };

  vendorSha256 = "sha256-XBfTVd3X3IDxLCAaNnijf6E5bw+AZ94UdOG9w7BOdBU=";

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
