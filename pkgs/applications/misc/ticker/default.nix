{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ticker";
  version = "4.6.2";

  src = fetchFromGitHub {
    owner = "achannarasappa";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-bNqwQwYuaWThpVVlZji0uiNKf8Ynxs00bAD+iSnbtm8=";
  };

  vendorHash = "sha256-cTJa170oFFPRQSg3njZk26XvzsRRdJqcsFokKUWJr6Q=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/achannarasappa/ticker/cmd.Version=v${version}"
  ];

  # Tests require internet
  doCheck = false;

  meta = with lib; {
    description = "Terminal stock ticker with live updates and position tracking";
    homepage = "https://github.com/achannarasappa/ticker";
    changelog = "https://github.com/achannarasappa/ticker/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      siraben
      sarcasticadmin
    ];
    mainProgram = "ticker";
  };
}
