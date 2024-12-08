{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, wrapGAppsHook4
, glib
, gtk4
, pango
, librsvg
}:

rustPlatform.buildRustPackage rec {
  pname = "regreet";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "rharish101";
    repo = "ReGreet";
    rev = version;
    hash = "sha256-MPLlHYTfDyL2Uy50A4lVke9SblXCErgJ24SP3kFuIPw=";
  };

  cargoHash = "sha256-dR6veXCGVMr5TbCvP0EqyQKTG2XM65VHF9U2nRWyzfA=";

  buildFeatures = [ "gtk4_8" ];

  nativeBuildInputs = [ pkg-config wrapGAppsHook4 ];
  buildInputs = [ glib gtk4 pango librsvg ];

  meta = with lib; {
    description = "Clean and customizable greeter for greetd";
    homepage = "https://github.com/rharish101/ReGreet";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fufexan ];
    platforms = platforms.linux;
    mainProgram = "regreet";
  };
}
