{stdenv, firefox, plugins}:

stdenv.mkDerivation {
  name = firefox.name;

  builder = ./builder.sh;
  makeWrapper = ../../../../build-support/make-wrapper/make-wrapper.sh;

  inherit firefox;

  # Let each plugin tell us (through its `mozillaPlugin') attribute
  # where to find the plugin in its tree.
  plugins = map (x: x ~ x.mozillaPlugin) plugins;

  meta = {
    description = firefox.meta.description + " (with various plugins)";
  };
}
