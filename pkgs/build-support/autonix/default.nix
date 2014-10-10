{ stdenv, fetchurl, callPackage }:

with stdenv.lib;


rec {
  callAutoPackage = callPackage ./call-auto-package.nix {};
  callAutoCollection = callPackage ./call-auto-collection.nix {};

  package = rec {
    propagateInputs = names: manifest:
      let propagate = input:
            if builtins.elem input.name names
              then input // { propagate = true; }
            else input;
      in manifest // {
        inputs = map propagate manifest.inputs;
      };

    nativeInputs = names: manifest:
      let native = input:
            if builtins.elem input.name names
              then input // { native = true; }
            else input;
      in manifest // {
        inputs = map native manifest.inputs;
      };

    userEnvPkgs = names: manifest:
      let userEnv = input:
            if builtins.elem input.name names
              then input // { userEnv = true; }
            else input;
      in manifest // {
        inputs = map userEnv manifest.inputs;
      };

    renameInput = old: new: mapInputNames (x: if x == old then new else x);

    mapInputs = f: manifest: manifest // { inputs = map f manifest.inputs; };

    mapInputNames = f: mapInputs (i: i // { name = f i.name; });

    filterInputs = f: manifest:
      manifest // { inputs = filter f manifest.inputs; };

    filterInputsByName = f: filterInputs (i: f i.name);

    addInput = i: addInputs [i];
    addInputs = inputs: manifest:
      manifest // { inputs = inputs ++ manifest.inputs; };

    input = n: { name = n; native = false; propagated = false; userEnv = false; };

    substInputs = attrs: mapInputs (i:
      if hasAttr i.name attrs
        then i // getAttr i.name attrs
      else i);
  };

  collection = {
    inherit (package) input;

    breakRecursion = name: package.filterInputsByName (n: n != name);

    perPackage = attrs: name: getAttrOr name attrs id;

    propagateInputs = names: const (package.propagateInputs names);
    nativeInputs = names: const (package.nativeInputs names);
    userEnvPkgs = names: const (package.userEnvPkgs names);
    renameInput = old: new: const (package.renameInput old new);
    mapInputs = f: const (package.mapInputs f);
    mapInputNames = f: const (package.mapInputNames f);
    filterInputs = f: const (package.filterInputs f);
    filterInputsByName = f: const (package.filterInputsByName f);
    addInput = i: const (package.addInput i);
    addInputs = inputs: const (package.addInputs inputs);
    substInputs = attrs: const (package.substInputs attrs);
  };
}
