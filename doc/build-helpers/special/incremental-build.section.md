# pkgs.buildIncremental.*  {#sec-incremental-build}

`pkgs.buildIncremental` provides a way to build derivations incrementally. It consists of two functions to make incremental builds using nix possible.

For hermeticity, Nix derivations do not allow any state to carry over between builds, making a transparent incremental build within a derivation impossible.

However, we can tell Nix explicitly what the previous build state was, by representing that previous state as a derivation output. This allows the passed build state to be used for an incremental build.

To build a derivation incrementally, the following steps needs to be fullfilled:
    * - run prepareIncrementalBuild on the desired derivation
    *   e.G `incrementalBuildArtifacts = (pkgs.buildIncremental.prepareIncrementalBuild pkgs.virtualbox);`
    * - change something you want in the sources of the package( e.G using source override)
    *   changedVBox = pkgs.virtuabox.overrideAttrs (old: {
    *      src = path/to/vbox/sources;
    *   }
    * - use `mkIncrementalBuild changedVBox buildOutput`
    * enjoy shorter build times

As Nix has no builtin support for the detection of the previous built derivation, a base version needs to be declared.  
To create the outputs later used as base version for incremental builds, the function `pkgs.buildIncremental.prepareIncrementalBuild` is used.  
The function takes the original derivation as an argument and transforms the output to a base version for an incremental build.  
While doing so, the original output is not created and the installation phase is overwritten to produce the incremental build artifacts.  

When the built artifacts of the base version of the derivation are created, the code can be modified and changes are built using the `pkgs.buildIncremental.mkIncrementalBuild` function.  
The `pkgs.buildIncremental.mkIncrementalBuild` function detects the changes in the code and places the output of the base version derivation within the build folder.   
Then, the build tool is able to detect the changes and makes the decision of which parts of the derivation needs to be recompiled and produces the output, as expected in the derivation, without incremental build support.


