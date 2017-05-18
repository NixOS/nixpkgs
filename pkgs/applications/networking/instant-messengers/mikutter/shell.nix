{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
  name = "mikutter-shell";
  buildInputs = with pkgs; [
    bundix
    bundler
    pkgconfig
    ruby
    gdk_pixbuf
    gtk2
    xorg.libXdmcp
    pcre
    pthread_stubs
  ];

  # the below must be set for the gtk2 gem to find gdkkeysyms.h
  CFLAGS = "-I${pkgs.gtk2.dev}/include/gtk-2.0 -I/non-existent-path";

  shellHook = ''
    truncate --size 0 Gemfile.lock
    bundle install --path=vendor/bundle
    rm -rf vendor .bundle
    bundix -d
  '';
}
