{ stdenv, lib, bundlerEnv, gpgme, ruby, ncurses, writeText, zlib, xapian
, pkgconfig, which }:

bundlerEnv {
  name = "sup-0.20.0";

  inherit ruby;
  gemfile = ./Gemfile;
  lockfile = ./Gemfile.lock;
  gemset = ./gemset.nix;

  meta = with lib; {
    description = "A curses threads-with-tags style email client";
    homepage    = http://supmua.org;
    license     = licenses.gpl2;
    maintainers = with maintainers; [ cstrahan lovek323 ];
    platforms   = platforms.unix;
  };
}
