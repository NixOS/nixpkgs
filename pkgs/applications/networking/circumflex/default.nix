{ lib, less, ncurses, buildGoModule, fetchFromGitHub, makeWrapper }:

buildGoModule rec {
  pname = "circumflex";
  version = "2.9.1";

  src = fetchFromGitHub {
    owner = "bensadeh";
    repo = "circumflex";
    rev = version;
    hash = "sha256-FgmtRARNyvO+Ivhwr2S12GLX+vlTFnsClXv1Y7sTCmU=";
  };

  vendorHash = "sha256-p4lIIu3rkzb1EfJ4GJeXPgQlxGN1dqyTlIC9BOE1o/Y=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/clx \
      --prefix PATH : ${lib.makeBinPath [ less ncurses ]}
  '';

  meta = with lib; {
    description = "A command line tool for browsing Hacker News in your terminal";
    homepage = "https://github.com/bensadeh/circumflex";
    license = licenses.agpl3;
    maintainers = with maintainers; [ mktip ];
    mainProgram = "clx";
  };
}
