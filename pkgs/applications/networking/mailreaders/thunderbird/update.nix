{ callPackage
, ...
}@args:

callPackage ../../browsers/firefox/update.nix ({
  baseUrl = "http://archive.mozilla.org/pub/thunderbird/releases/";
} // (builtins.removeAttrs args ["callPackage"]))
