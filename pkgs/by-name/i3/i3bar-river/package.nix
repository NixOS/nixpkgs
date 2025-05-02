{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, pango
}:

rustPlatform.buildRustPackage rec {
  pname = "i3bar-river";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "MaxVerevkin";
    repo = "i3bar-river";
    rev = "v${version}";
    hash = "sha256-mLRB4o8FR/R9QUpRkcNppiE2XcWFWE05wPxuKdxG18M=";
  };

  cargoHash = "sha256-INjuI3XTSzAjLqk/P+cd7rMhXsOBDSqMaZZN9kFyreg=";

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
