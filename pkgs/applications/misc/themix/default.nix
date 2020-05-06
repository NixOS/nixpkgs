{ callPackage }:

rec {
  themix-gui = callPackage ./gui {
    unwrapped = callPackage ./gui/unwrapped.nix {};
    plugins = with themixPlugins; [
    ];
  };

  themixPlugins = {
  };
}
