{ lib, less, ncurses, buildGoModule, fetchFromGitHub, makeWrapper }:

buildGoModule rec {
  pname = "circumflex";
<<<<<<< HEAD
  version = "3.2";
=======
  version = "2.8.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "bensadeh";
    repo = "circumflex";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-3cu5Y9Z20CbFN+4/2LLM3pcXofuc8oztoZVPhDzFLas=";
  };

  vendorHash = "sha256-w9WDbNvnaRgZ/rpI450C7AA244AXRE8u960xZnAiXn4=";
=======
    hash = "sha256-6g1x19FLC7IdShlcCNlKMuPQX1sBU5+eFr0CzTSu4nE=";
  };

  vendorHash = "sha256-rztg2mIuyoqpI9SKQsp0ASMT4HO4h0/bxLX7+xtfLzo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
