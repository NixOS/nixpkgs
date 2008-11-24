{pkgs}:

with pkgs;

rec {

  makeSourceTarball = args: import ./make-source-tarball.nix
    ({inherit stdenv autoconf automake libtool;} // args);

  nixBuild = args: import ./nix-build.nix (
    { inherit stdenv;
      doCoverageAnalysis = false;
    } // args);

  coverageAnalysis = args: nixBuild (
    { inherit lcov;
      doCoverageAnalysis = true;
    } // args);

}