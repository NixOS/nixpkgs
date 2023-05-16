{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
<<<<<<< HEAD
, wrapGAppsHook
, glib
, gtk4
, pango
, librsvg
=======
, glib
, gtk4
, pango
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

rustPlatform.buildRustPackage rec {
  pname = "regreet";
<<<<<<< HEAD
  version = "0.1.1";
=======
  version = "0.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "rharish101";
    repo = "ReGreet";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-MPLlHYTfDyL2Uy50A4lVke9SblXCErgJ24SP3kFuIPw=";
  };

  cargoHash = "sha256-dR6veXCGVMr5TbCvP0EqyQKTG2XM65VHF9U2nRWyzfA=";

  buildFeatures = [ "gtk4_8" ];

  nativeBuildInputs = [ pkg-config wrapGAppsHook];
  buildInputs = [ glib gtk4 pango librsvg ];
=======
    hash = "sha256-9Wae2sYiRpWYXdBKsSNKhG5RhIun/Ro9xIV4yl1/pUc=";
  };

  cargoHash = "sha256-yDfUD5Uag3UM/2Q7ofvh6iGcB3n21m1gKo7SKqTWamc=";

  buildFeatures = [ "gtk4_8" ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ glib gtk4 pango ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Clean and customizable greeter for greetd";
    homepage = "https://github.com/rharish101/ReGreet";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fufexan ];
    platforms = platforms.linux;
<<<<<<< HEAD
    mainProgram = "regreet";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
