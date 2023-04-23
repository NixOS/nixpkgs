{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, glib
, gtk4
, pango
}:

rustPlatform.buildRustPackage rec {
  pname = "regreet";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "rharish101";
    repo = "ReGreet";
    rev = version;
    hash = "sha256-9Wae2sYiRpWYXdBKsSNKhG5RhIun/Ro9xIV4yl1/pUc=";
  };

  cargoHash = "sha256-yDfUD5Uag3UM/2Q7ofvh6iGcB3n21m1gKo7SKqTWamc=";

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
