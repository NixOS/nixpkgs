{ callPackage }: builtins.mapAttrs (pname: attrs: callPackage ./generic.nix (attrs // { inherit pname; })) {
  signal-desktop = {
    dir = "Signal";
    version = "6.5.1";
    hash = "sha256-At4ILl6nHltP1TMI5cjK7gE4NENAccS4MPMHXJoGveM=";
  };
  signal-desktop-beta = {
    dir = "Signal Beta";
    version = "6.6.0-beta.1";
    hash = "sha256-txSvMg7Q+r9UWJMC9Rj2XQ8y1WN3xphMruvOZok/VPk=";
  };
}
