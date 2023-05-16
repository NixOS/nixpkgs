{ lib
, buildGoModule
, fetchFromGitHub
, pkg-config
, gtk3
, gtk-layer-shell
}:

buildGoModule rec {
  pname = "nwg-dock";
<<<<<<< HEAD
  version = "0.3.7";
=======
  version = "0.3.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-Ci+221sXlaqr164OYVhj8sqGSwlpFln2RRUiGoTO8Fk=";
  };

  vendorHash = "sha256-GW+shKOCwU8yprEfBeAPx1RDgjA7cZZzXDG112bdZ6k=";
=======
    sha256 = "sha256-RCVG38Y8VV7qGz/CaOZ4aw4Sg3PQdrB29zZqATjvYDQ=";
  };

  vendorSha256 = "sha256-WDygnKdldZda4GadfStHWsDel1KLdzjVjw0RxmnFPRE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [ "-s" "-w" ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gtk3 gtk-layer-shell ];

  meta = with lib; {
    description = "GTK3-based dock for sway";
    homepage = "https://github.com/nwg-piotr/nwg-dock";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dit7ya ];
  };
}
