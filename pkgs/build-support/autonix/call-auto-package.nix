{ pkgs, newScope, stdenv, fetchurl }:

path:
{ manifest ? null
, manifestRules ? []
, derivationRules ? []
, scope ? pkgs
}:

with stdenv.lib;

let callPackage = newScope scope; in

let
  manifestFile = path + /manifest.nix;
  defaultsFile = path + /default.nix;
  manifestOrig = manifest;
  manifestRulesOrig = manifestRules;
  derivationRulesOrig = derivationRules;
in

assert (manifest != null) || (builtins.pathExists manifestFile);

let
  traceThis = x: builtins.trace x x;
  isBuildInput = input: !(input.native || input.propagated || input.userEnv);
  isNativeBuildInput = input: input.native && !input.propagated;
  isPropagatedNativeBuildInput = input: input.native && input.propagated;
  isPropagatedBuildInput = input: !input.native && input.propagated;
  isPropagatedUserEnvPkg = input: input.userEnv;
in
let
  defaultDerivationRules = [
    (auto: attrs:
      let
        resolveInputs = f:
          let resolve = input:
                if hasAttr input.name scope
                  then
                    let pkg = getAttr input.name scope;
                    in if isDerivation pkg then [pkg.outPath] else []
                else [];
          in concatMap resolve (filter f auto.inputs);
      in attrs // {
        inherit (auto) name;
        src = fetchurl auto.src;
        enableParallelBuilding = true;
        buildInputs = resolveInputs isBuildInput;
        nativeBuildInputs = resolveInputs isNativeBuildInput;
        propagatedBuildInputs = resolveInputs isPropagatedBuildInput;
        propagatedNativeBuildInputs = resolveInputs isPropagatedNativeBuildInput;
        propagatedUserEnvPkgs = resolveInputs isPropagatedUserEnvPkg;
      }
    )
  ];
in
let

  trueManifest =
    if manifest == null
      then (import manifestFile {})
    else manifest;

  localDefaults =
    if (builtins.pathExists defaultsFile)
      then (callPackage defaultsFile {})
      else {};

  manifestRules =
    manifestRulesOrig
    ++ (localDefaults.manifestRules or []);

  derivationRules =
    derivationRulesOrig
    ++ (localDefaults.derivationRules or [])
    ++ defaultDerivationRules;

in let

  manifest = fold (f: x: f x) manifestOrig manifestRules;

in

stdenv.mkDerivation
  (fold (f: as: f as) {} (map (f: f manifest) derivationRules))
