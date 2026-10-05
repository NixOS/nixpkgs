{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  udev,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "makima";
  version = "0.10.3";

  src = fetchFromGitHub {
    owner = "cyber-sushi";
    repo = "makima";
    rev = "v${finalAttrs.version}";
    hash = "sha256-/+m6nWvZg5q3rPAu80xXImISmLzTpXiugu1m3M8QupQ=";
  };

  cargoHash = "sha256-vq680vbpvJRUV3waSMgiWm8oiu9m1JGTXzBco6lEvKc=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ udev ];

  meta = {
    description = "Linux daemon to remap and create macros for keyboards, mice and controllers";
    homepage = "https://github.com/cyber-sushi/makima";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ByteSudoer ];
    platforms = lib.platforms.linux;
    mainProgram = "makima";
  };
})
