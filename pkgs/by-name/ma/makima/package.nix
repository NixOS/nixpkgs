{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, udev
}:

rustPlatform.buildRustPackage rec{
  pname = "makima";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "cyber-sushi";
    repo = "makima";
    rev = "v${version}";
    hash = "sha256-3S4J4fdCn/eqgT9g0WmS5kQHr7LysBn03RzHvagm5jg=";
  };

  cargoHash = "sha256-YCs37IYiYxjh2uBZvHliDZRu68J4mXCCYpWlPHtw+0Q=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ udev ];

  meta = with lib; {
    description = "Linux daemon to remap and create macros for keyboards, mice and controllers";
    homepage = "https://github.com/cyber-sushi/makima";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ByteSudoer ];
    platforms = platforms.linux;
    mainProgram = "makima";
  };
}
