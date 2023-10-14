{ callPackage }: builtins.mapAttrs (pname: attrs: callPackage ./generic.nix (attrs // { inherit pname; })) {
  signal-desktop = {
    dir = "Signal";
    version = "6.32.0";
    hash = "sha256-FZ2wG3nkgIndeoUfXag/9jftXGDSY/MNpT8mqSZpJzA=";
  };
  signal-desktop-beta = {
    dir = "Signal Beta";
    version = "6.33.0-beta.1";
    hash = "sha256-FLCZvRYUysiE8BLMJVnn0hOkA3km0z383AjN6JvOyWI=";
  };
}
