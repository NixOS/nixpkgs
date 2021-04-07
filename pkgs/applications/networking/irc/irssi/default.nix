{ lib, stdenv, fetchurl, fetchpatch, pkg-config, ncurses, glib, openssl, perl, libintl, libgcrypt, libotr }:

stdenv.mkDerivation rec {
  pname = "irssi";
  version = "1.2.2";

  src = fetchurl {
    url = "https://github.com/irssi/irssi/releases/download/${version}/${pname}-${version}.tar.gz";
    sha256 = "0g2nxazn4lszmd6mf1s36x5ablk4999g1qx7byrnvgnjsihjh62k";
  };

  # Fix irssi on GLib >2.62 input being stuck after entering a NUL byte
  # See https://github.com/irssi/irssi/issues/1180 - remove after next update.
  patches = fetchpatch {
    url = "https://github.com/irssi/irssi/releases/download/1.2.2/glib-2-63.patch";
    sha256 = "1ad1p7395n8dfmv97wrf751wwzgncqfh9fp27kq5kfdvh661da1i";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ ncurses glib openssl perl libintl libgcrypt libotr ];

  configureFlags = [
    "--with-proxy"
    "--with-bot"
    "--with-perl=yes"
    "--with-otr=yes"
    "--enable-true-color"
  ];

  meta = {
    homepage    = "https://irssi.org";
    description = "A terminal based IRC client";
    platforms   = lib.platforms.unix;
    maintainers = with lib.maintainers; [ lovek323 ];
    license     = lib.licenses.gpl2Plus;
  };
}
