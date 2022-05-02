{ lib }:

rec {

  /* imports a flake.nix without acknowledging its lock file, useful for
    referencing subflakes from a parent flake. The second argument allows
    specifying the inputs of this flake.

    Example:
      callLocklessFlake {
        path = ./directoryContainingFlake;
        inputs = { inherit nixpkgs; };
      }
  */
  callLocklessFlake = { path, inputs ? { } }:
    let
      self = { outPath = path; } //
        ((import (path + "/flake.nix")).outputs (inputs // { self = self; }));
    in
    self;


  /* Builds a map from <attr>=value to <attr>.<system>=value for each system,
     except for the `hydraJobs` attribute, where it maps the inner attributes,
     from hydraJobs.<attr>=value to hydraJobs.<attr>.<system>=value.

     Example:
       eachSystem [ "x86_64-linux" "aarch64-linux" ] (system: { hello = 42; })
       => { hello = { aarch64-linux = 42; x86_64-linux = 42; }; }
  */
  eachSystem = systems: f:
    let
      # Used to match Hydra's convention of how to define jobs. Basically transforms
      #
      #     hydraJobs = {
      #       hello = <derivation>;
      #       haskellPackages.aeson = <derivation>;
      #     }
      #
      # to
      #
      #     hydraJobs = {
      #       hello.x86_64-linux = <derivation>;
      #       haskellPackages.aeson.x86_64-linux = <derivation>;
      #     }
      #
      # if the given flake does `eachSystem [ "x86_64-linux" ] { ... }`.
      pushDownSystem = system: merged:
        builtins.mapAttrs
          (name: value:
            if ! (builtins.isAttrs value) then value
            else if lib.isDerivation value then (merged.${name} or {}) // { ${system} = value; }
            else pushDownSystem system (merged.${name} or {}) value);

      # Merge together the outputs for all systems.
      op = attrs: system:
        let
          ret = f system;
          op = attrs: key:
            let
              appendSystem = key: system: ret:
                if key == "hydraJobs"
                  then (pushDownSystem system (attrs.hydraJobs or {}) ret.hydraJobs)
                  else { ${system} = ret.${key}; };
            in attrs //
              {
                ${key} = (attrs.${key} or { })
                  // (appendSystem key system ret);
              }
          ;
        in
        builtins.foldl' op attrs (builtins.attrNames ret);
    in
    builtins.foldl' op { } systems;
}
