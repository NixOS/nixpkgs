# Perlless {#sec-perlless}

Render your system completely perlless (i.e. without the perl interpreter). This
includes a mechanism so that your build fails if it contains a Nix store path
that references the string "perl".
