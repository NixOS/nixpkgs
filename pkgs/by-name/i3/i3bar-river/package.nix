{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, pango
}:

rustPlatform.buildRustPackage rec {
  pname = "i3bar-river";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "MaxVerevkin";
    repo = "i3bar-river";
    rev = "v${version}";
    hash = "sha256-Rw4jildX3t853hIwEem/KzTBUyO3a/kour3dvSw8DVA=";
  };

  cargoHash = "sha256-uGzXEeQ2yzk8HEdgY/gTxqaCoMO25kbiD1XrpJwmVp4=";

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
