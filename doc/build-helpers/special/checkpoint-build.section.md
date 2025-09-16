# pkgs.checkpointBuildTools  {#sec-checkpoint-build}

`pkgs.checkpointBuildTools` provides a way to build derivations incrementally. It consists of two functions to make checkpoint builds using Nix possible.

For hermeticity, Nix derivations do not allow any state to be carried over between builds, making a transparent incremental build within a derivation impossible.

However, we can tell Nix explicitly what the previous build state was, by representing that previous state as a derivation output. This allows the passed build state to be used for an incremental build.

To change a normal derivation to a checkpoint based build, these steps must be taken:
  ```nix
  {
    checkpointArtifacts = (pkgs.checkpointBuildTools.prepareCheckpointBuild pkgs.virtualbox);
  }
  ```
  ```nix
  {
    changedVBox = pkgs.virtualbox.overrideAttrs (old: {
      src = path/to/vbox/sources;
    });
  }
  ```
  - use `mkCheckpointBuild changedVBox checkpointArtifacts`
  - enjoy shorter build times

## Example {#sec-checkpoint-build-example}
```nix
{
  pkgs ? import <nixpkgs> { },
}:
let
  inherit (pkgs.checkpointBuildTools) prepareCheckpointBuild mkCheckpointBuild;
  helloCheckpoint = prepareCheckpointBuild pkgs.hello;
  changedHello = pkgs.hello.overrideAttrs (_: {
    doCheck = false;
    postPatch = ''
      sed -i 's/Hello, world!/Hello, Nix!/g' src/hello.c
    '';
  });
in
mkCheckpointBuild changedHello helloCheckpoint
```
