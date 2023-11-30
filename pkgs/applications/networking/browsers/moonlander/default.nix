{ lib
, stdenv
, fetchFromSourcehut
, rustPlatform
, atk
, cairo
, gdk-pixbuf
, glib
, gtk3
, pango
, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "moonlander";
  version = "unstable-2021-05-23";

  src = fetchFromSourcehut {
    owner = "~admicos";
    repo = "moonlander";
    rev = "abfb9cd421092b73609a32d0a04d110294a48f5e";
    hash = "sha256-kpaJRZPPVj8QTFfOx7nq3wN2jmyYASou7cgf+XY2RVU=";
  };

  cargoHash = "sha256-DL/EtZomrZlOFjUgNm6qnrB1MpXApkYKGubi+dB8aho=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    atk
    cairo
    gdk-pixbuf
    glib
    gtk3
    pango
  ];

  meta = with lib; {
    description = "Just another \"fancy\" Gemini client";
    homepage = "https://sr.ht/~admicos/moonlander/";
    license = licenses.mit;
    maintainers = [];
    broken = true; # on hydra as of 2023-11-16, upstream is inactive
  };
}
