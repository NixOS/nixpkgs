{ stdenv, buildGoPackage, fetchgit }:

buildGoPackage rec {
  name    = "cointop-unstable-${version}";
  version = "2018-05-03";
  rev     = "08acd96082682347d458cd4f861e2debd3255745";

  goPackagePath = "github.com/miguelmota/cointop";

  src = fetchgit {
    inherit rev;
    url    = "https://github.com/miguelmota/cointop";
    sha256 = "14savz48wzrfpm12fgnnndpl3mpzx7wsch4jrnm3rmrfdabdx7mi";
  };

  goDeps = ./deps.nix;

  meta = {
    description = "The fastest and most interactive terminal based UI application for tracking cryptocurrencies";
    longDescription = ''
    cointop is a fast and lightweight interactive terminal based UI application
    for tracking and monitoring cryptocurrency coin stats in real-time.

    The interface is inspired by htop and shortcut keys are inspired by vim.
    '';
    homepage  = https://cointop.sh;
    platforms = stdenv.lib.platforms.linux; # cannot test others
    maintainers = [ ];
    license = stdenv.lib.licenses.asl20;
  };
}
