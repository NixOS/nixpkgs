{ pkgs, ... }:

let
  pkgs' = pkgs.extend (self: super: super.prefer-remote-fetch self super);

  check =
    fn: args:
    let
      drv = pkgs'.testers.invalidateFetcherByDrvHash fn args;
    in
    if drv.preferLocalBuild then throw "Fetcher must not prefer local builds" else drv;

in
pkgs'.callPackage (
  {
    testers,
    fetchgit,
    fetchFromGitHub,
    fetchurl,
    fetchzip,
    ...
  }:
  {
    fetchgit = check fetchgit {
      name = "simple-nix-source";
      url = "https://github.com/NixOS/nix";
      rev = "9d9dbe6ed05854e03811c361a3380e09183f4f4a";
      sha256 = "sha256-7DszvbCNTjpzGRmpIVAWXk20P0/XTrWZ79KSOGLrUWY=";
    };

    fetchFromGitHub = check fetchFromGitHub {
      name = "simple-nix-source";
      owner = "NixOS";
      repo = "nix";
      rev = "9d9dbe6ed05854e03811c361a3380e09183f4f4a";
      hash = "sha256-7DszvbCNTjpzGRmpIVAWXk20P0/XTrWZ79KSOGLrUWY=";
    };

    fetchurl = check fetchurl {
      url = "https://gist.github.com/glandium/01d54cefdb70561b5f6675e08f2990f2/archive/2f430f0c136a69b0886281d0c76708997d8878af.zip";
      sha256 = "sha256-J/ZWC23GmFfew/56NQvPqKzqkWgjOaPvbMicFJnuJxI=";
    };

    fetchzip = check fetchzip {
      url = "https://gist.github.com/glandium/01d54cefdb70561b5f6675e08f2990f2/archive/2f430f0c136a69b0886281d0c76708997d8878af.zip";
      sha256 = "sha256-0ecwgL8qUavSj1+WkaxpmRBmu7cvj53V5eXQV71fddU=";
    };
  }
) { }
