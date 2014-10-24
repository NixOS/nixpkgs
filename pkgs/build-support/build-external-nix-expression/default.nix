{ pkgs }: /* nix package collection attrset */

{ src /* result of fetchurl/fetchgit/... */
, nixExpressionFile ? "./default.nix"
}:

with pkgs;

let
  unpack = src: runCommand "unpacked-source" { inherit src; } ''
    mkdir -p "$out"
    unpackPhase
    cp -r "$sourceRoot"/* "$sourceRoot"/.[!.]* "$sourceRoot"/..?* "$out"
  '';
  nixExpressionFile_ = (unpack src) + "/" + nixExpressionFile;
in
callPackage nixExpressionFile_ { }
