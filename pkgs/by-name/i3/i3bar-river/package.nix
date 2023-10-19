{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, pango
}:

rustPlatform.buildRustPackage rec {
  pname = "i3bar-river";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "MaxVerevkin";
    repo = "i3bar-river";
    rev = "v${version}";
    hash = "sha256-c5R5V5J1ETBl6JAdNDSxa94OeMyqbTAUmJHJCo1B+WQ=";
  };

  cargoHash = "sha256-D/WKv8rhb/ZGuVEZDp83PZxJydHbnZUQp+kVNlMBUCs=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ pango ];

  meta = with lib; {
    description = "A port of i3bar for river";
    homepage = "https://github.com/MaxVerevkin/i3bar-river";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nicegamer7 ];
    mainProgram = "i3bar-river";
    platforms = platforms.linux;
  };
}
