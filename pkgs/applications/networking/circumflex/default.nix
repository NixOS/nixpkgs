{ lib, less, ncurses, buildGoModule, fetchFromGitHub, makeWrapper }:

buildGoModule rec {
  pname = "circumflex";
  version = "3.1.3";

  src = fetchFromGitHub {
    owner = "bensadeh";
    repo = "circumflex";
    rev = version;
    hash = "sha256-KY3Jf0Y6ZAQciwImv7Oz0nQ5eEwm7XwOlAx3ijqDF0k=";
  };

  vendorHash = "sha256-ms7TvCXQdkrlWp1pGj3ja+ACodt7z6sP3E373xHxA34=";

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
