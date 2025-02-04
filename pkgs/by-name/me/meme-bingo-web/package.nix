{
  lib,
  fetchFromGitea,
  rustPlatform,
  makeWrapper,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "meme-bingo-web";
  version = "1.2.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "annaaurora";
    repo = "meme-bingo-web";
    rev = "v${version}";
    hash = "sha256-0ahyyuihpwmAmaBwZv7lNmjuy8UsAm1a9XUhWcYq76w=";
  };

  cargoHash = "sha256-bcx6iu0kmFdNvJJ6Jo9JuJpucYSeZO8U3Ox1TuFaBO0=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    mkdir -p $out/share/meme-bingo-web
    cp -r {templates,static} $out/share/meme-bingo-web/

    wrapProgram $out/bin/meme-bingo-web \
      --set MEME_BINGO_TEMPLATES $out/share/meme-bingo-web/templates \
      --set MEME_BINGO_STATIC $out/share/meme-bingo-web/static
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Play meme bingo using this neat web app";
    mainProgram = "meme-bingo-web";
    homepage = "https://codeberg.org/annaaurora/meme-bingo-web";
    license = licenses.unlicense;
    maintainers = with maintainers; [ annaaurora ];
  };
}
