{ lib, less, ncurses, buildGoModule, fetchFromGitHub, makeWrapper }:

buildGoModule rec {
  pname = "circumflex";
  version = "2.8.1";

  src = fetchFromGitHub {
    owner = "bensadeh";
    repo = "circumflex";
    rev = version;
    hash = "sha256-hFhK1/ck37lfZJ2wpk1MGCfYEANhh8qzTb8m1t7EoBo=";
  };

  vendorHash = "sha256-rwqY6illp5+h/oHOnVg6QfZ6tRFJOamwqJxQx/zlpyI=";

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
