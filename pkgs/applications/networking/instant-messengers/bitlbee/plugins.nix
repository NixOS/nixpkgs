{ lib, stdenv, bitlbee }:

with lib;

plugins:

stdenv.mkDerivation {
  inherit bitlbee plugins;
  name = "bitlbee-plugins";
  buildInputs = [ bitlbee plugins ];
  phases = [ "installPhase" ];
  installPhase = ''
    mkdir -p $out/lib/bitlbee
    for plugin in $plugins; do
      for thing in $(ls $plugin/lib/bitlbee); do
        ln -s $plugin/lib/bitlbee/$thing $out/lib/bitlbee/
      done
    done
  '';
}
