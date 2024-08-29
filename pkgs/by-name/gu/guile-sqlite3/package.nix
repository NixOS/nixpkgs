{
  lib,
  autoreconfHook,
  fetchFromGitea,
  guile,
  pkg-config,
  sqlite,
  stdenv,
  texinfo,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "guile-sqlite3";
  version = "0.1.3";

  src = fetchFromGitea {
    domain = "notabug.org";
    owner = "guile-sqlite3";
    repo = "guile-sqlite3";
    rev = "v${finalAttrs.version}";
    hash = "sha256-C1a6lMK4O49043coh8EQkTWALrPolitig3eYf+l+HmM=";
  };

  nativeBuildInputs = [
    autoreconfHook
    guile
    pkg-config
    texinfo
  ];

  buildInputs = [
    guile
    sqlite
  ];

  makeFlags = [ "GUILE_AUTO_COMPILE=0" ];

  strictDeps = true;

  doCheck = true;

  enableParallelBuilding = true;

  meta = {
    homepage = "https://notabug.org/guile-sqlite3/guile-sqlite3";
    description = "Guile bindings for the SQLite3 database engine";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ AndersonTorres ];
    inherit (guile.meta) platforms;
  };
})
