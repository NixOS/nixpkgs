# Linking NixOS tests to packages {#sec-linking-nixos-tests-to-packages}

You can link NixOS module tests to the packages that they exercised,
so that the tests can be run automatically during code review when the package gets changed.
This is
[described in the nixpkgs manual](https://nixos.org/manual/nixpkgs/stable/#ssec-nixos-tests-linking).
