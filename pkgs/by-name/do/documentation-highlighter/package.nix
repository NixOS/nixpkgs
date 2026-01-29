{ lib, runCommand }:
runCommand "documentation-highlighter"
  {
    meta = {
      description = "Highlight.js sources for the Nix Ecosystem's documentation";
      homepage = "https://highlightjs.org";
      license = lib.licenses.bsd3;
      platforms = lib.platforms.all;
    };
    src = ./src;
  }
  ''
    cp -r "$src" "$out"
  ''
