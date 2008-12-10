{pkgs}:

with pkgs;

rec {

  makeSourceTarball = args: import ./make-source-tarball.nix (
    { inherit autoconf automake libtool;
      stdenv = stdenvNew;
    } // args);

  nixBuild = args: import ./nix-build.nix (
    { inherit stdenv;
    } // args);

  coverageAnalysis = args: nixBuild (
    { inherit lcov;
      doCoverageAnalysis = true;
    } // args);

  rpmBuild = args: import ./rpm-build.nix vmTools args;

  debBuild = args: import ./debian-build.nix {inherit vmTools fetchurl;} (
    { inherit stdenv checkinstall;
    } // args);

}
