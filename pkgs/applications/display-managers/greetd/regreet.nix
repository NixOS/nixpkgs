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
  version = "unstable-2023-03-19";

  src = fetchFromGitHub {
    owner = "rharish101";
    repo = "ReGreet";
    rev = "fd496fa00abc078570ac85a47ea296bfc275222a";
    hash = "sha256-pqCtDoycFKV+EFLEodoTCDSO5L+dOVtdjN6DVgJ/7to=";
  };

  cargoHash = "sha256-8FbA5FFJuRt5tvW1HGaaEZcr5g6OczcBeic1hCTQmUw=";

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
