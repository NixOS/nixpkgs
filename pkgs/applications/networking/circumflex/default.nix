{ lib, less, ncurses, buildGoModule, fetchFromGitHub, makeWrapper }:

buildGoModule rec {
  pname = "circumflex";
  version = "2.6";

  src = fetchFromGitHub {
    owner = "bensadeh";
    repo = "circumflex";
    rev = version;
    hash = "sha256-pcY2PXiOazKAi8mAAbmftXDae01fcUw/u9JPOHQVclI=";
  };

  vendorHash = "sha256-rF1Hu4Pf9AF2MTx4GAPmzSn0M38uTxPS1bsAkO23SdI=";

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
