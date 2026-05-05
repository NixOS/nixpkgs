{ helix }:

(helix.withGrammars (_: [ ])).overrideAttrs { strictDeps = true; }
