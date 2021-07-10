# based on easystroke-git from Arch AUR
# as found on https://github.com/teu5us/easystroke-nix

{ pkgs, ... }:

with pkgs;

stdenv.mkDerivation rec {
  name = "easystroke";
  version = "patched-2018-12-05";
  src = fetchTarball {
    url = "https://github.com/thjaeger/easystroke/archive/refs/tags/0.6.0.tar.gz";
    sha256 = "0kgzmwxqgbq3cgp2rvj09j9rk6h7ynbibim4mins3wzalgwy68dv";
  };
  nativeBuildInputs = [ gnutar bzip2 gnumake boost.dev gtkmm3.dev dbus-glib.dev pkg-config git xorg.xorgserver.dev ];
  buildInputs = [ boost gtkmm3 xorg.libXtst intltool dbus-glib xorg.xorgserver ];
  buildPhase = ''
    # cd $src/easystroke
    make
  '';
  patches = [
    ./sigc.patch
    ./dont-ignore-xshape-when-saving.patch
    ./add-toggle-option.patch
    ./abs.patch
  ];
  installPhase = ''
    mkdir -p $out
    make install PREFIX="$out"
  '';
}
