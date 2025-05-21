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
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "newsraft";
  version = "0.30";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "newsraft";
    repo = "newsraft";
    rev = "newsraft-${finalAttrs.version}";
    hash = "sha256-h9gjw2EjWWNdyQT2p4wgWlz4TNitDBX5fPbNNH9/th4=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    curl
    expat
    gumbo
    ncurses
    sqlite
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  postInstall = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    install -Dm444 doc/newsraft.desktop -t $out/share/applications
  '';

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
