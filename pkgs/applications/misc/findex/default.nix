{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, wrapGAppsHook
, atk
, cairo
, gdk-pixbuf
, glib
, gtk3
, pango
}:

rustPlatform.buildRustPackage rec {
  pname = "findex";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "mdgaziur";
    repo = "Findex";
    rev = "v${version}";
    hash = "sha256-XsLkQZq1uOJTCF2f8Ym4KZPZhlJZD261IAkkt68/Lbw=";
  };

  cargoHash = "sha256-yHjP1+o8S6Eq2La0Ev3dK5xZxnAlGNy3zuX3IQoIX1M=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    atk
    cairo
    gdk-pixbuf
    glib
    gtk3
    pango
  ];

  meta = with lib; {
    description = "Highly customizable application finder written in Rust and uses Gtk3";
    homepage = "https://github.com/mdgaziur/Findex";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    badPlatforms = [ "aarch64-darwin" "x86-64-darwin" ];
    maintainers = with maintainers; [ pinkcreeper100 ];
  };
}
