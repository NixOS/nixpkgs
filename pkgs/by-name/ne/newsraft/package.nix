{
  lib,
  stdenv,
  fetchFromCodeberg,
  pkg-config,
  curl,
  expat,
  gumbo,
  sqlite,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "newsraft";
  version = "0.36";

  src = fetchFromCodeberg {
    owner = "newsraft";
    repo = "newsraft";
    rev = "newsraft-${finalAttrs.version}";
    hash = "sha256-xnnFN7bOwZ7a0AnnWqIQ/M/W2fwG+47VfPb2T5OG05U=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    curl
    expat
    gumbo
    sqlite
  ];

  makeFlags = [ "PREFIX=$(out)" ];
  installTargets = "install install-desktop";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Feed reader for terminal";
    homepage = "https://codeberg.org/newsraft/newsraft";
    changelog = "https://codeberg.org/newsraft/newsraft/releases/tag/newsraft-${finalAttrs.version}";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ luftmensch-luftmensch ];
    mainProgram = "newsraft";
    platforms = lib.platforms.all;
  };
})
