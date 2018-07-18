# to run: nix-env -qa -f find-missing-versions.nix

{ condition ? v: (builtins.parseDrvName v.name).version == ""
, conditionName ? "missing version numbers"
, nixpkgs ? import <nixpkgs> { config = {
                                 allowUnsupportedSystem = true;
                                 allowInsecure = true;
                                 allowUnfree = true;
                               };
                             }
}:

with nixpkgs.lib;

let toplevel = filterAttrs (n: v: let v' = tryEval v; in
                    v'.success
                 && isDerivation v'.value
                 && v'.value.meta.available or false
                 && (tryEval v'.value.name).success
                 && (condition v'.value)
               ) nixpkgs;
    badPackages = attrNames toplevel;
    inherit (nixpkgs) lib;
    inherit (builtins) elem tryEval currentSystem;
    inherit (lib) filterAttrs isDerivation const;
in if badPackages == [] then []
   else throw ''
Some packages are ${conditionName}. Here is the list:

- ${concatStringsSep "\n- " badPackages}
   ''
