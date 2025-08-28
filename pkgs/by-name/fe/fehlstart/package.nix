{
  lib,
  stdenv,
  pkg-config,
  gtk3,
  glib,
  keybinder3,
  fetchFromGitea,
}:

stdenv.mkDerivation {
  pname = "fehlstart";
  version = "0.5-unstable-2025-01-12";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "chuvok";
    repo = "fehlstart";
    rev = "cf08d6c3964da9abc8d1af0725894fef62352064";
    hash = "sha256-qq0IhLzSvYnooPb4w+lno8P/tbedrDKTk27HGtQlp2I=";
  };

  patches = [ ./use-nix-profiles.patch ];

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    gtk3
    keybinder3
  ];

  env.NIX_CFLAGS_COMPILE = "-I${lib.getDev glib}/include/gio-unix-2.0";

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Small desktop application launcher with reasonable memory footprint";
    homepage = "https://codeberg.org/Chuvok/fehlstart";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.mounium ];
    platforms = lib.platforms.linux;
    mainProgram = "fehlstart";
  };
}
