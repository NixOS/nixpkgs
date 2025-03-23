{
  lib,
  stdenv,
  fetchFromGitea,
  pkg-config,
  curl,
  expat,
  gumbo,
  ncurses,
  sqlite,
  yajl,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "newsraft";
  version = "0.29";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "newsraft";
    repo = "newsraft";
    rev = "newsraft-${finalAttrs.version}";
    hash = "sha256-6rDnGVOApSURuXom+XxPPOG7lxMbHGTL+4Oqrx+Jq2w=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    curl
    expat
    gumbo
    ncurses
    sqlite
    yajl
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Feed reader for terminal";
    homepage = "https://codeberg.org/grisha/newsraft";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [
      arthsmn
      luftmensch-luftmensch
    ];
    mainProgram = "newsraft";
    platforms = lib.platforms.all;
  };
})
