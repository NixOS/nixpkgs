{ lib, bundlerEnv, ruby }:

bundlerEnv {
  name = "sup-0.22.1";

  inherit ruby;

  # Updated with:
  # nix-shell -p bundix -p bundler -p ncurses -p ruby -p which -p zlib -p libuuid
  # bundle install --path ./vendor
  # bundix
  gemfile = ./Gemfile;
  lockfile = ./Gemfile.lock;
  gemset = ./gemset.nix;

  meta = with lib; {
    description = "A curses threads-with-tags style email client";
    homepage    = http://sup-heliotrope.github.io;
    license     = licenses.gpl2;
    maintainers = with maintainers; [ cstrahan lovek323 ];
    platforms   = platforms.unix;
  };
}
