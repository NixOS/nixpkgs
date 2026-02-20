{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "epilys-bb";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "epilys";
    repo = "bb";
    rev = "v${finalAttrs.version}";
    hash = "sha256-szeEBiolg2rVD2XZoNrncUYnA8KPhWwhQPYsjuxp904=";
  };

  cargoHash = "sha256-xUNvVG5jdAXsro2P8je3LFxqMycJEB4j7w3abf6jilw=";

  meta = {
    description = "Clean, simple, and fast process viewer";
    homepage = "https://nessuent.xyz/bb.html";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ cafkafk ];
    platforms = lib.platforms.linux;
    mainProgram = "bb";
  };
})
