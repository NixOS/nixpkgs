{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, glib
, gtk4
, pango
}:

rustPlatform.buildRustPackage {
  pname = "regreet";
  version = "unstable-2023-02-27";

  src = fetchFromGitHub {
    owner = "rharish101";
    repo = "ReGreet";
    rev = "2bbabe90f112b4feeb0aea516c265daaec8ccf2a";
    hash = "sha256-71ji4x/NUE4qmBuO5PkWTPE1a0uPXqJSwW1Ai1amPJE=";
  };

  cargoHash = "sha256-rz2eMMhoMtzBXCH6ZJOvGuYLeHSWga+Ebc4+ZO8Kk1g=";

  buildFeatures = [ "gtk4_8" ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ glib gtk4 pango ];

  meta = with lib; {
    description = "Clean and customizable greeter for greetd";
    homepage = "https://github.com/rharish101/ReGreet";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fufexan ];
    platforms = platforms.linux;
  };
}
