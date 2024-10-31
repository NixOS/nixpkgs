{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "meow";
  version = "2.1.3";

  src = fetchFromGitHub {
    owner = "PixelSergey";
    repo = "meow";
    rev = "v${version}";
    hash = "sha256-PB871c137uxxPaYbV6NB8kECVUrQWTeVz0ciVLHrph4=";
  };

  cargoHash = "sha256-4BoKZUgt4jf8jy2HU3J6RuT0GXNqkJnBUR09wNlNm7E=";

  postInstall = ''
    ln -s $out/bin/meow-cli $out/bin/meow
  '';

  meta = {
    description = "Print ASCII cats to your terminal";
    homepage = "https://github.com/PixelSergey/meow";
    license = lib.licenses.mit;
    mainProgram = "meow";
    maintainers = with lib.maintainers; [ pixelsergey ];
  };
}
