{ lib }:

let
  inherit (lib) isDerivation exec;
  inherit (builtins) isAttrs mapAttrs attrNames foldl';
in rec {

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

  /*
    Builds a map from <attr>=value to <attr>.<system>=value for each system,
    except for the `hydraJobs` attribute, where it maps the inner attributes,
    from hydraJobs.<attr>=value to hydraJobs.<attr>.<system>=value.
  */
  eachSystem = systems: f:
    let

      /*
        Used to match Hydra's convention of how to define jobs. Basically transforms

            hydraJobs = {
              hello = <derivation>;
              haskellPackages.aeson = <derivation>;
            }

        to

            hydraJobs = {
              hello.x86_64-linux = <derivation>;
              haskellPackages.aeson.x86_64-linux = <derivation>;
            }

        if the given flake does `eachSystem [ "x86_64-linux" ] { ... }`.
      */
      pushDownSystem = system: merged:
        mapAttrs
          (name: value:
            if ! (isAttrs value) then value
            else if isDerivation value then (merged.${name} or {}) // { ${system} = value; }
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
                ${key} = (attrs.${key} or { }) // (appendSystem key system ret);
              }
          ;
        in
        foldl' op attrs (attrNames ret);
    in
    foldl' op { } systems
  ;

  /*
    Returns the structure used by `nix app`

    Example:
      mkApp neovim
      => { type = "app"; program = "/nix/store/.../bin/nvim"; }
  */
  mkApp = drv: {
    type = "app";
    program = exec drv;
  };

  /*
    Returns the structure used by `nix app`

    Example:
      mkApp libnotify "notify-send"
      => { type = "app"; program = "/nix/store/.../bin/notify-send"; }
  */
  mkApp' = drv: binName: {
    type = "app";
    program = "${drv}/bin/${binName}";
  };

}
