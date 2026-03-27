{
  lib,
  fetchFromCodeberg,
  rustPlatform,
  makeWrapper,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "meme-bingo-web";
  version = "1.2.0";

  src = fetchFromCodeberg {
    owner = "annaaurora";
    repo = "meme-bingo-web";
    rev = "v${finalAttrs.version}";
    hash = "sha256-0ahyyuihpwmAmaBwZv7lNmjuy8UsAm1a9XUhWcYq76w=";
  };

  cargoHash = "sha256-5GpNVcnwWjxYgIXGoFkuf5CFD46kxxQwb3t0/i/2nFM=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    mkdir -p $out/share/meme-bingo-web
    cp -r {templates,static} $out/share/meme-bingo-web/

    wrapProgram $out/bin/meme-bingo-web \
      --set MEME_BINGO_TEMPLATES $out/share/meme-bingo-web/templates \
      --set MEME_BINGO_STATIC $out/share/meme-bingo-web/static
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Play meme bingo using this neat web app";
    mainProgram = "meme-bingo-web";
    homepage = "https://codeberg.org/annaaurora/meme-bingo-web";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ annaaurora ];
  };
})
