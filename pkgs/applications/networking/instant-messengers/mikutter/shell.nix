{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
  name = "mikutter-shell";
  buildInputs = with pkgs; [
    bundix
    bundler
  ];

  shellHook = ''
    export MIKUTTER_CONFROOT="/homeless-shelter"
    truncate --size 0 Gemfile.lock
    bundle lock
    bundle package --path=vendor/bundle --no-install
    rm -rf vendor .bundle
    bundix -d
  '';
}
