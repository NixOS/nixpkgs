{ callPackage
, ...
}@args:

callPackage ../../browsers/firefox/update.nix ({
  baseUrl = "https://archive.mozilla.org/pub/thunderbird/releases/";
} // (builtins.removeAttrs args ["callPackage"]))
