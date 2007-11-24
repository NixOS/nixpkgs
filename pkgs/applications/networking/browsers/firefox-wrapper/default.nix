args: with args;

stdenv.mkDerivation {
  name = firefox.name + "-with-plugins";

  builder = ./builder.sh;
  makeWrapper = ../../../../build-support/make-wrapper/make-wrapper.sh;

  inherit firefox;

  nameSuffix = (if args ? nameSuffix then args.nameSuffix else "");

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
