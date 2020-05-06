{ callPackage }:

rec {
  themix-gui = callPackage ./gui {
    unwrapped = callPackage ./gui/unwrapped.nix {};
    plugins = with themixPlugins; [
      import-images
      theme-oomox
    ];
  };

  themixPlugins = {
    import-images = callPackage ./import-images {};
    theme-oomox = callPackage ./theme-oomox {};
  };
}
