# pkgs.mkShell {#sec-pkgs-mkShell}

`pkgs.mkShell` is a specialized `stdenv.mkDerivation` that removes some
repetition when using it with `nix-shell` (or `nix develop`).

## Usage {#sec-pkgs-mkShell-usage}

Here is a common usage example:

```nix
{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  packages = [ pkgs.gnumake ];

  inputsFrom = [ pkgs.hello pkgs.gnutar ];

  shellHook = ''
    export DEBUG=1
  '';
}
```

## Attributes

* `name` (default: `nix-shell`). Set the name of the derivation.
* `packages` (default: `[]`). Add executable packages to the `nix-shell` environment.
* `inputsFrom` (default: `[]`). Add build dependencies of the listed derivations to the `nix-shell` environment.
* `shellHook` (default: `""`). Bash statements that are executed by `nix-shell`.

... all the attributes of `stdenv.mkDerivation`.

## Building the shell

This derivation output will contain a text file that contains a reference to
all the build inputs. This is useful in CI where we want to make sure that
every derivation, and its dependencies, build properly. Or when creating a GC
root so that the build dependencies don't get garbage-collected.
