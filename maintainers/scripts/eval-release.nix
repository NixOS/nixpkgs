# Evaluate `release.nix' like Hydra would. Too bad nix-instantiate can't to do this.

let
  inherit (import ../../lib) isDerivation mapAttrs;

  trace = if builtins.getEnv "VERBOSE" == "1" then builtins.trace else (x: y: y);

  rel = removeAttrs (import ../../pkgs/top-level/release.nix { }) [
    "tarball"
    "unstable"
  ];

  # Add the ‘recurseForDerivations’ attribute to ensure that
  # nix-instantiate recurses into nested attribute sets.
  recurse =
    path: attrs:
    if (builtins.tryEval attrs).success then
      if isDerivation attrs then
        if (builtins.tryEval attrs.drvPath).success then
          { inherit (attrs) name drvPath; }
        else
          { failed = true; }
      else if attrs == null then
        { }
      else
        {
          recurseForDerivations = true;
        }
        // mapAttrs (
          n: v:
          let
            path' = path ++ [ n ];
          in
          trace path' (recurse path' v)
        ) attrs
    else
      { };

in
recurse [ ] rel
