{ lib, less, ncurses, buildGoModule, fetchFromGitHub, makeWrapper }:

buildGoModule rec {
  pname = "circumflex";
  version = "3.6";

  src = fetchFromGitHub {
    owner = "bensadeh";
    repo = "circumflex";
    rev = version;
    hash = "sha256-FzJUmF2X4Iyf83cIEa8b8EFCcWUyYEZBVyvXuhiaaWM=";
  };

  vendorHash = "sha256-x/NgcodS/hirXJHxBHeUP9MgOBHq1yQWHprMrlpqsas=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/clx \
      --prefix PATH : ${lib.makeBinPath [ less ncurses ]}
  '';

  meta = with lib; {
    description = "Command line tool for browsing Hacker News in your terminal";
    homepage = "https://github.com/bensadeh/circumflex";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ mktip ];
    mainProgram = "clx";
  };
}
