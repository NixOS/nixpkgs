{ lib, less, ncurses, buildGoModule, fetchFromGitHub, makeWrapper }:

buildGoModule rec {
  pname = "circumflex";
  version = "3.5";

  src = fetchFromGitHub {
    owner = "bensadeh";
    repo = "circumflex";
    rev = version;
    hash = "sha256-w5QdFvF+kIxt27rg/uXjd+G0Dls7oYhmFew+O2NoaVg=";
  };

  vendorHash = "sha256-F9mzGP5b9dcmnT6TvjjbRq/isk1o8vM/5yxWUaZrnaw=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/clx \
      --prefix PATH : ${lib.makeBinPath [ less ncurses ]}
  '';

  meta = with lib; {
    description = "A command line tool for browsing Hacker News in your terminal";
    homepage = "https://github.com/bensadeh/circumflex";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ mktip ];
    mainProgram = "clx";
  };
}
