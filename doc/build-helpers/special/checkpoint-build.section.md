# pkgs.checkpointBuildTools.*  {#sec-checkpoint-build}

`pkgs.checkpointBuildTools` provides a way to build derivations incrementally. It consists of two functions to make checkpoint builds using nix possible.

For hermeticity, Nix derivations do not allow any state to carry over between builds, making a transparent incremental build within a derivation impossible.

However, we can tell Nix explicitly what the previous build state was, by representing that previous state as a derivation output. This allows the passed build state to be used for an incremental build.

To change a normal derivation to a checkpoint based build, these steps must be taken:
  * apply `prepareCheckpointBuild` on the desired derivation
    e.g. `checkpointArtifacts = (pkgs.checkpointBuildTools.prepareCheckpointBuild pkgs.virtualbox);`
  - change something you want in the sources of the package. (e.g. using a source override)
    *   changedVBox = pkgs.virtualbox.overrideAttrs (old: {
    *      src = path/to/vbox/sources;
    *   }
    * - use `mkCheckpointedBuild changedVBox buildOutput`
    * enjoy shorter build times

As Nix intentionally has no built-in support for the detection of the previously built derivation, a base version must be declared.
To create the outputs later used as base version for checkpoint builds, the function `pkgs.checkpointBuildTools.prepareCheckpointBuild` is used.
The function takes the original derivation as an argument and transforms the output to a base version for an checkpoint build build.
While doing so, the original output is not created and the installation phase is overwritten to produce the checkpoint artifacts.

When the built artifacts of the base version of the derivation are created, the code can be modified and changes are built using the `pkgs.checkpointBuildTools.mkCheckpointedBuild` function.
The `pkgs.checkpointBuildTools.mkCheckpointedBuild` function detects the changes in the code and places the output of the base version derivation within the build folder.
Then, the build tool is able to detect the changes and makes the decision of which parts of the derivation needs to be recompiled and produces the output, as expected in the derivation, without checkpoint build support.
