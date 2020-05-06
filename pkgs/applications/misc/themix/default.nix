{ callPackage }:

rec {
  themix-gui = callPackage ./gui {
    unwrapped = callPackage ./gui/unwrapped.nix {};
    plugins = with themixPlugins; [
      import-images
    ];
  };

  themixPlugins = {
    import-images = callPackage ./import-images {};
  };
}
