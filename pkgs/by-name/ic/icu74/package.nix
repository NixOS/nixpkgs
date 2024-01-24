
{ stdenv, lib, fetchurl, fixDarwinDylibNames, nativeBuildRoot, testers, buildRootOnly ? false }:

let
  version = "74.2";
  license = fetchurl {
    url = "https://github.com/unicode-org/icu/raw/release-${lib.replaceStrings [ "." ] [ "-" ] version}/LICENSE";
    hash = "sha256-F1EM96WLSHm4h+wFpF1yzxtzVE3Z7H5y8gEQ7RBCKe4=";
  };
in
(import ./base.nix {
  inherit version;
  sha256 = "sha256-Xk+xHWo+a4WvtV3o2opxU48dj9ZPzok5hrN9YOW7AJE=";
} { inherit stdenv lib fetchurl fixDarwinDylibNames nativeBuildRoot testers buildRootOnly; }).overrideAttrs {
  # https://unicode-org.atlassian.net/browse/ICU-22601
  postPatch = "cp --remove-destination ${license} ../LICENSE";
}
