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
  version = "3.7";

  src = fetchFromGitHub {
    owner = "bensadeh";
    repo = "circumflex";
    rev = version;
    hash = "sha256-jjtjOT8lFPsk300Q9EtsX/w8Bck0pwrS/GyouoBsZ+0=";
  };

  vendorHash = "sha256-Nlv8H5YqHrqACW2kEXg+mkc3bCgXVudrSNfyu+xeFBA=";

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
