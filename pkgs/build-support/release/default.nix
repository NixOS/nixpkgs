{pkgs}:

with pkgs;

rec {

  sourceTarball = args: import ./source-tarball.nix (
    { inherit stdenv autoconf automake libtool;
    } // args);

  makeSourceTarball = sourceTarball; # compatibility

  binaryTarball = args: import ./binary-tarball.nix (
    { inherit stdenv;
    } // args);

  antBuild = args: import ./ant-build.nix (
    { inherit stdenv;
    } // args);

  nixBuild = args: import ./nix-build.nix (
    { inherit stdenv;
    } // args);

  coverageAnalysis = args: nixBuild (
    { inherit lcov;
      doCoverageAnalysis = true;
    } // args);

  rpmBuild = args: import ./rpm-build.nix (
    { inherit vmTools;
    } // args);

  debBuild = args: import ./debian-build.nix (
    { inherit stdenv vmTools checkinstall;
    } // args);

}
