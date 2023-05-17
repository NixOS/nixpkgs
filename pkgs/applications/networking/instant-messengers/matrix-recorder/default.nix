{ lib, stdenv, pkgs }:
(import ./composition.nix {
  inherit pkgs;
  inherit (stdenv.hostPlatform) system;
})."package".override {
  postInstall = ''
    mkdir "$out/bin"
    echo '#!/bin/sh' >> "$out/bin/matrix-recorder"
    echo "'${pkgs.nodejs_14}/bin/node'" \
         "'$out/lib/node_modules/matrix-recorder/matrix-recorder.js'" \
         '"$@"' >> "$out/bin/matrix-recorder"
    echo '#!/bin/sh' >> "$out/bin/matrix-recorder-to-html"
    echo 'cd "$1"' >> "$out/bin/matrix-recorder-to-html"
    echo "test -d templates/ || ln -sfT '$out/lib/node_modules/matrix-recorder/templates' templates" >> "$out/bin/matrix-recorder-to-html"
    echo "'${pkgs.nodejs_14}/bin/node'" \
         "'$out/lib/node_modules/matrix-recorder/recorder-to-html.js'" \
         '.' >> "$out/bin/matrix-recorder-to-html"
    chmod a+x "$out/bin/matrix-recorder"
    chmod a+x "$out/bin/matrix-recorder-to-html"
  '';
  meta = {
    description = "Matrix message recorder";
    homepage = "https://gitlab.com/argit/matrix-recorder/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.raskin ];
  };
}
