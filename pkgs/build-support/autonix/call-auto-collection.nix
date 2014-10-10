{ pkgs, stdenv, callAutoPackage, callPackage }:

path:
{ manifest ? null
, manifestRules ? []
, derivationRules ? []
, scope ? pkgs
}:

with stdenv.lib;

let manifestFile = path + /manifest.nix; in

assert (manifest != null) || (builtins.pathExists manifestFile);

let manifestOrig = manifest; in

let

  manifest =
    if manifestOrig == null
      then (import manifestFile {})
    else manifest;

  callSubPackage = name: pkgManifest:
    callAutoPackage (path + ("/" + name)) {
      manifest = pkgManifest;
      manifestRules = map (f: f name) manifestRules;
      derivationRules = map (f: f name) derivationRules;
      scope = scope // self;
    };

  self = mapAttrs callSubPackage manifest;

in self
