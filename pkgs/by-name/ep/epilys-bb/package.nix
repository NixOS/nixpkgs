{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "epilys-bb";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "epilys";
    repo = "bb";
    rev = "v${version}";
    hash = "sha256-szeEBiolg2rVD2XZoNrncUYnA8KPhWwhQPYsjuxp904=";
  };

  cargoHash = "sha256-hQuWRcg9dWYYaHXxocJ+XG1K7aTWLhR2RZVUc4geJLI=";

  meta = with lib; {
    description = "Clean, simple, and fast process viewer";
    homepage = "https://nessuent.xyz/bb.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ cafkafk ];
    platforms = platforms.linux;
    mainProgram = "bb";
  };
}
