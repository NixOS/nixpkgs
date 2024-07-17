{
  lib,
  fetchFromGitea,
  rustPlatform,
  nix-update-script,
  imagemagick,
  makeWrapper,
}:
let
  version = "2.10.0";
in
rustPlatform.buildRustPackage {
  pname = "wallust";
  inherit version;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "explosion-mental";
    repo = "wallust";
    rev = version;
    hash = "sha256-0kPmr7/2uVncpCGVOeIkYlm2M0n9+ypVl7bQ9HnqLb4=";
  };

  cargoHash = "sha256-p1NKEppBYLdCsTY7FHPzaGladLv5HqIVNJxSoFJOx50=";

  nativeBuildInputs = [ makeWrapper ];

  postFixup = ''
    wrapProgram $out/bin/wallust \
      --prefix PATH : "${lib.makeBinPath [ imagemagick ]}"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A better pywal";
    homepage = "https://codeberg.org/explosion-mental/wallust";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      onemoresuza
      iynaix
    ];
    downloadPage = "https://codeberg.org/explosion-mental/wallust/releases/tag/${version}";
    mainProgram = "wallust";
  };
}
