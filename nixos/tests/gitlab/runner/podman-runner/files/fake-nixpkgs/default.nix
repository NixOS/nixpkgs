_:
throw ''
  This container doesn't include nixpkgs.

  The best way to work around that is to pin your dependencies. See
    https://nix.dev/tutorials/first-steps/towards-reproducibility-pinning-nixpkgs.html

  Or if you must, override the NIX_PATH environment variable with eg:
    "NIX_PATH=nixpkgs=channel:nixos-unstable"
''
