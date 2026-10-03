#!/usr/bin/env bash

### To update clj2nix
# $ nix-prefetch-github hlolli clj2nix

nix-shell --run "clj2nix deps.edn deps.nix" -E '
with import ../../../../.. { };
mkShell {
  buildInputs = [(callPackage (fetchFromGitHub {
    owner = "hlolli";
    repo = "clj2nix";
    rev = "b9a28d4a920d5d680439b1b0d18a1b2c56d52b04";
    hash = "sha256-QyvBEfHhbgwjkKOnmy5DUdrw6VJpKXrKefxFYZSkHTU=";
  }) {})];
}
'
