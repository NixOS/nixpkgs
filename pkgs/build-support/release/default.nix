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

  rpmBuild = args: import ./rpm-build.nix vmTools args;

  debBuild = args: import ./debian-build.nix vmTools (
    { inherit stdenv;
    } // args);

}
