{
  lib,
  stdenv,
  fetchFromGitea,
  pkg-config,
  curl,
  expat,
  gumbo,
  sqlite,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "newsraft";
  version = "0.31";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "newsraft";
    repo = "newsraft";
    rev = "newsraft-${finalAttrs.version}";
    hash = "sha256-XnVGt9frUKeAjxYk2cr3q3a5HpqVH0CHnNiKdTTBnqA=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    curl
    expat
    gumbo
    sqlite
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  postInstall = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    install -Dm444 doc/newsraft.desktop -t $out/share/applications
  '';

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-D_DARWIN_C_SOURCE";

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
