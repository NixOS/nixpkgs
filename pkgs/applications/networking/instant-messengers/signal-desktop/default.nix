{ callPackage }: builtins.mapAttrs (pname: attrs: callPackage ./generic.nix (attrs // { inherit pname; })) {
  signal-desktop = {
    dir = "Signal";
    version = "6.5.1";
    hash = "sha256-At4ILl6nHltP1TMI5cjK7gE4NENAccS4MPMHXJoGveM=";
  };
  signal-desktop-beta = {
    dir = "Signal Beta";
    version = "6.5.0-beta.2";
    hash = "sha256-cAX9oU3bJrTOH3RbbfUK+49OiRSLjEZLdpJNOMAa94I=";
  };
}
