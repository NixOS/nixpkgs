{ stdenv, fetchurl, callPackage }:

with stdenv.lib;


rec {
  callAutoPackage = callPackage ./call-auto-package.nix {};
  callAutoCollection = callPackage ./call-auto-collection.nix {};

  propagateInputs = names: name: manifest:
    let propagate = input:
          if builtins.elem input.name names
            then input // { propagate = true; }
          else input;
    in manifest // {
      inputs = map propagate manifest.inputs;
    };

  nativeInputs = names: name: manifest:
    let native = input:
          if builtins.elem input.name names
            then input // { native = true; }
          else input;
    in manifest // {
      inputs = map native manifest.inputs;
    };

  userEnvPkgs = names: name: manifest:
    let userEnv = input:
          if builtins.elem input.name names
            then input // { userEnv = true; }
          else input;
    in manifest // {
      inputs = map userEnv manifest.inputs;
    };

  renameInput = old: new: mapInputNames (x: if x == old then new else x);

  mapInputs = f: name: manifest: manifest // { inputs = map f manifest.inputs; };

  mapInputNames = f: mapInputs (i: i // { name = f i.name; });

  filterInputs = f: name: manifest:
    manifest // { inputs = filter f manifest.inputs; };

  filterInputsByName = f: filterInputs (i: f i.name);

  breakRecursion = name: attrs: attrs // {
    inputs = filter (input: input.name != name) attrs.inputs;
  };

  perPackage = attrs: name: (getAttrOr name attrs (const id)) name;

  addInput = i: name: manifest: manifest // { inputs = [i] ++ manifest.inputs; };

  input = n: { name = n; native = false; propagated = false; userEnv = false; };
}
