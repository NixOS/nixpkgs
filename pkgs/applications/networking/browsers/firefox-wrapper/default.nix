{stdenv, firefox, nameSuffix ? "", makeWrapper, plugins}:

stdenv.mkDerivation {
  name = firefox.name + "-with-plugins";

  buildInputs = [makeWrapper];

  buildCommand = ''
    makeWrapper "${firefox}/bin/firefox" "$out/bin/firefox${nameSuffix}" \
        --suffix-each MOZ_PLUGIN_PATH ':' "$plugins" \
        --suffix-contents PATH ':' "$(filterExisting $(addSuffix /extra-bin-path $plugins))"
  '';

  # Let each plugin tell us (through its `mozillaPlugin') attribute
  # where to find the plugin in its tree.
  plugins = map (x: x + x.mozillaPlugin) plugins;

  meta = {
    description =
      firefox.meta.description
      + " (with plugins: "
      + (let lib = import ../../../../lib;
        in lib.concatStrings (lib.intersperse ", " (map (x: x.name) plugins)))
      + ")";
  };
}
