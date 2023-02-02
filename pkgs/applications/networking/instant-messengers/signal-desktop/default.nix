{ callPackage }: builtins.mapAttrs (pname: attrs: callPackage ./generic.nix (attrs // { inherit pname; })) {
  signal-desktop = {
    dir = "Signal";
    version = "6.4.1";
    hash = "sha256-/Rrph74nVr64Z6blNNn3oMM25YK92MZY/vuF1d+r6Yc=";
  };
  signal-desktop-beta = {
    dir = "Signal Beta";
    version = "6.5.0-beta.2";
    hash = "sha256-cAX9oU3bJrTOH3RbbfUK+49OiRSLjEZLdpJNOMAa94I=";
  };
}
