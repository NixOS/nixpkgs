# to run: nix-env -qa -f find-missing-versions.nix

{ condition
, conditionName
, nixpkgs ? import ../.. { }
}:

with nixpkgs.lib;

let toplevel = filterAttrs (n: v: let v' = tryEval v; in
                    v'.success
                 && isDerivation v'.value
                 && v'.value.meta.available or false
                 && (tryEval v'.value.name).success
                 && !(v.meta.isHook or false)
                 && (condition v'.value)
               ) nixpkgs;
    badPackages = attrNames toplevel;
    inherit (nixpkgs) lib;
    inherit (builtins) elem tryEval currentSystem;
    inherit (lib) filterAttrs isDerivation const;
in if badPackages == [] then []
   else throw ''
Some packages are ${conditionName}. Here is the list:

- [ ] ${concatStringsSep "\n- [ ] " badPackages}
   ''
