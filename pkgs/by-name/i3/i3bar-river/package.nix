{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, pango
}:

rustPlatform.buildRustPackage rec {
  pname = "i3bar-river";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "MaxVerevkin";
    repo = "i3bar-river";
    rev = "v${version}";
    hash = "sha256-AXa+K+njXkrJeqABD04WHpmvAzAL1Mw11ZhCfFNJxhY=";
  };

  cargoHash = "sha256-tNuv+D75wox3HlUZSJJ67KEBKmGJXBkXHfvDsNHeM6A=";

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
