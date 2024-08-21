{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, pango
}:

rustPlatform.buildRustPackage rec {
  pname = "i3bar-river";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "MaxVerevkin";
    repo = "i3bar-river";
    rev = "v${version}";
    hash = "sha256-tG23bdEKp8+9RMS1fpW8EVe+bAdjQp7nVW0eHl3eYSQ=";
  };

  cargoHash = "sha256-nSzGWpnyGRus9qCTPAd+BM4KsujSNyRmFUCc4Lg4D5k=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ pango ];

  meta = with lib; {
    description = "Port of i3bar for river";
    homepage = "https://github.com/MaxVerevkin/i3bar-river";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nicegamer7 ];
    mainProgram = "i3bar-river";
    platforms = platforms.linux;
  };
}
