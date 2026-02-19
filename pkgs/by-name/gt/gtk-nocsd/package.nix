{
  lib,
  stdenv,
  libadwaita,
  glib,
  pkg-config,
  fetchFromGitea,
}:

stdenv.mkDerivation {
  pname = "gtk-nocsd";
  version = "0-unstable-2026-02-22";
  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "MorsMortium";
    repo = "GTK-NoCSD";
    rev = "c9544f7e3e12d6ed54a18360fab9255dae6e05af";
    hash = "sha256-qTs/E0MBCJ/G9s/aRuMQEHMoQm57Rtn8LM1B9Xg/q7c=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libadwaita
    glib
  ];
  makeFlags = [
    "DESTDIR=$(out)"
    "PREFIX=" # don't prepend /usr/local to paths
    "NOOPT=1" # don't install /opt symlink flatpak workaround, which has no use with Nix
    "NODOC=1" # don't install examples for a system-wide installation using profile.d files
  ];
  meta = {
    description = "LD_PRELOAD library to disable CSD in GTK3/4, LibHandy, and LibAdwaita apps";
    homepage = "https://codeberg.org/MorsMortium/GTK-NoCSD";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ mrbananaegg ];
    platforms = lib.platforms.linux;
  };

}
