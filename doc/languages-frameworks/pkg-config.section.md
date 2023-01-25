# pkg-config {#sec-pkg-config}

*pkg-config* is a unified interface for declaring and querying built C/C++ libraries.

Nixpkgs provides a couple of facilities for working with this tool.

 - A [setup hook](#setup-hook-pkg-config) bundled with in the `pkg-config` package, to bring a derivation's declared build inputs into the environment.
 - The [`validatePkgConfig` setup hook](https://nixos.org/manual/nixpkgs/stable/#validatepkgconfig), for packages that provide pkg-config modules.
 - The `defaultPkgConfigPackages` package set: a set of aliases, named after the modules they provide. This is meant to be used by language-to-nix integrations. Hand-written packages should use the normal Nixpkgs attribute name instead.
