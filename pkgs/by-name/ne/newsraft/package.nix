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
  version = "0.35";

  src = fetchFromCodeberg {
    owner = "newsraft";
    repo = "newsraft";
    rev = "newsraft-${finalAttrs.version}";
    hash = "sha256-c1IlPs+GxwDeUCpyQ6oy9iLC3YNLCJpjkj1gnwY7lxA=";
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
