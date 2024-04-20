# Perlless {#sec-perlless}

::: {.warning}
If you enable this profile, you will NOT be able to switch to a new
configuration and thus you will not be able to rebuild your system with
nixos-rebuild!
:::

Render your system completely perlless (i.e. without the perl interpreter). This
includes a mechanism so that your build fails if it contains a Nix store path
that references the string "perl".
