{ lib, runCommand }:
runCommand "documentation-highlighter"
  {
    pname = "documentation-highlighter";
    version = "11.12.0";

    meta = {
      description = "Highlight.js sources for the Nix Ecosystem's documentation";
      homepage = "https://highlightjs.org";
      license = lib.licenses.bsd3;
      platforms = lib.platforms.all;
    };
  }
  ''
    cp -r ${./src} "$out"
  ''
