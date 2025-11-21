{
  lib,
  stdenv,
  fetchFromGitHub,
  fontconfig,
  harfbuzz,
  libX11,
  libXft,
  ncurses,
  gd,
  glib,
  pkg-config,
}:

stdenv.mkDerivation {
  pname = "st-snazzy";
  version = "0.8.5-unstable-2024-09-06";

  src = fetchFromGitHub {
    owner = "siduck";
    repo = "st";
    rev = "a7582f96afdee6bf0793cd0d8f84b755fd6aabf6";
    hash = "sha256-wohkmDsm26kqFGQKuY6NuBQsifT7nZNgrLqLFsU+Vog=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    fontconfig
    harfbuzz
    libX11
    libXft
    ncurses
    gd
    glib
  ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];
  env.TERMINFO = "${placeholder "out"}/share/terminfo";

  meta = {
    homepage = "https://github.com/siduck/st";
    description = "Snazzy terminal (suckless + beautiful)";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pouya ];
    platforms = lib.platforms.linux;
  };
}
