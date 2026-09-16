{
  lib,
  stdenv,
  libadwaita,
  glib,
  patchelf,
  pkg-config,
  fetchFromGitea,
}:

stdenv.mkDerivation rec {
  pname = "gtk-nocsd";
  version = "4.8";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "MorsMortium";
    repo = "GTK-NoCSD";
    rev = version;
    hash = "sha256-ZFKTHPolSMWQd03LzHB/n6SdvNQy+NBRAxMQLGgZNOg=";
  };

  nativeBuildInputs = [
    patchelf
    pkg-config
  ];

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

  postFixup = ''
    patchelf --add-rpath ${glib}/lib \
    "$out/lib/libgtk-nocsd.so.0"
  '';

  meta = {
    description = "LD_PRELOAD library to disable CSD in GTK3/4, LibHandy, and LibAdwaita apps";
    homepage = "https://codeberg.org/MorsMortium/GTK-NoCSD";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ mrbananaegg ];
    platforms = lib.platforms.linux;
  };

}
