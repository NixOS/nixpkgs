{
  lib,
  runCommandLocal,
  bitlbee,
}:

plugins:
runCommandLocal "bitlbee-plugins"
  {
    inherit plugins;
    buildInputs = [
      bitlbee
      plugins
    ];
  }
  ''
    mkdir -p $out/lib/bitlbee
    for plugin in $plugins; do
      for thing in $(ls $plugin/lib/bitlbee); do
        ln -s $plugin/lib/bitlbee/$thing $out/lib/bitlbee/
      done
    done
  ''
