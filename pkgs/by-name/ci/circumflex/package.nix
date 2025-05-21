{
  lib,
  less,
  ncurses,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
}:

buildGoModule rec {
  pname = "circumflex";
  version = "3.8";

  src = fetchFromGitHub {
    owner = "bensadeh";
    repo = "circumflex";
    rev = version;
    hash = "sha256-qponQtfpAXQxpAhkXaylgzpsvbccTIz9kmhdI4tPuNQ=";
  };

  vendorHash = "sha256-HTrV2zK4i5gN2msIl0KTwjdmEDLjFz5fMCig1YPIC1A=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/clx \
      --prefix PATH : ${
        lib.makeBinPath [
          less
          ncurses
        ]
      }
  '';

  meta = with lib; {
    description = "Command line tool for browsing Hacker News in your terminal";
    homepage = "https://github.com/bensadeh/circumflex";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ mktip ];
    mainProgram = "clx";
  };
}
