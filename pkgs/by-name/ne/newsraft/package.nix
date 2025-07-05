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
  installTargets = "install install-desktop";

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-D_DARWIN_C_SOURCE";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Feed reader for terminal";
    homepage = "https://codeberg.org/newsraft/newsraft";
    changelog = "https://codeberg.org/newsraft/newsraft/releases/tag/newsraft-${finalAttrs.version}";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [
      arthsmn
      luftmensch-luftmensch
    ];
    mainProgram = "newsraft";
    platforms = lib.platforms.all;
  };
})
