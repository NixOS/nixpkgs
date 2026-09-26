/*
  This package, `biber-for-tectonic`, provides a compatible version of `biber`
  as an optional runtime dependency of `tectonic`.

  The development of tectonic is slowing down recently, such that its `biber`
  dependency has been lagging behind the one in the nixpkgs `texlive` bundle.
  See:

  https://github.com/tectonic-typesetting/tectonic/discussions/1122

  It is now feasible to track the biber dependency in nixpkgs, as the
  version bump is not very frequent, and it would provide a more complete
  user experience of tectonic in nixpkgs.
*/

{
  lib,
  fetchFromGitHub,
  fetchpatch,
  biber,
}:

let
  version = "2.17";
in
(biber.override {
  /*
    It is necessary to first override the `version` data here, which is
    passed to `buildPerlModule`, and then to `mkDerivation`.

    If we simply do `biber.overrideAttrs` the resulting package `name`
    would be incorrect, since it has already been preprocessed by
    `buildPerlModule`.
  */
  texlive.pkgs.biber.texsource = {
    inherit version;
    inherit (biber) pname meta;
  };
}).overrideAttrs
  (prevAttrs: {
    src = fetchFromGitHub {
      owner = "plk";
      repo = "biber";
      rev = "v${version}";
      hash = "sha256-Tt2sN2b2NGxcWyZDj5uXNGC8phJwFRiyH72n3yhFCi0=";
    };
    patches = [
      # Perl>=5.36.0 compatibility
      (fetchpatch {
        url = "https://patch-diff.githubusercontent.com/raw/plk/biber/pull/411.patch";
        hash = "sha256-osgldRVfe3jnMSOMnAMQSB0Ymc1s7J6KtM2ig3c93SE=";
      })
    ];
    meta = prevAttrs.meta // {
      maintainers = with lib.maintainers; [
        doronbehar
        bryango
      ];
    };
  })
