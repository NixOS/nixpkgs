{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook4,
  glib,
  gtk4,
  pango,
  librsvg,
}:

rustPlatform.buildRustPackage rec {
  pname = "regreet";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "rharish101";
    repo = "ReGreet";
    rev = version;
    hash = "sha256-ubKSqt3axp46ECIKwq9K1aHTPeuMQ3fCx6aRlhXh2F0=";
  };

  cargoHash = "sha256-Gwz1xs6OhrBb4xOuUUmxDVKxTC2lyp4Ckzi+9bnaRgo=";

  buildFeatures = [ "gtk4_8" ];

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];
  buildInputs = [
    glib
    gtk4
    pango
    librsvg
  ];

  meta = with lib; {
    description = "Clean and customizable greeter for greetd";
    homepage = "https://github.com/rharish101/ReGreet";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fufexan ];
    platforms = platforms.linux;
    mainProgram = "regreet";
  };
}
