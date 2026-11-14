# Shared helpers for non-systemd service manager backends (dinit, runit, s6).
# These backends translate the abstract service API (see lib/services/service.nix)
# into the configuration formats of their respective init systems.
#
# Everything here is additive: it does not change how existing service managers
# (systemd) translate services.
{ lib }:

let
  inherit (lib)
    concatLists
    filter
    mapAttrsToList
    mkOption
    types
    ;
in
rec {
  # Joins service names the same way the systemd backend does:
  # "" + "foo" == "foo", "foo" + "" == "foo", "foo" + "bar" == "foo-bar".
  # Sub-services are prefixed with the dashed name of their parent level.
  dash =
    before: after:
    if after == "" then
      before
    else if before == "" then
      after
    else
      "${before}-${after}";

  /**
    Flattens the recursive service tree into a list of records:
    `{ name, parentPrefix, service }`

    - `name`: absolute dashed name of the service
    - `parentPrefix`: absolute dashed name of the level above ("" for
      top-level services); sibling dependencies resolve to
      `dash parentPrefix depName`
    - `service`: the evaluated service configuration

    Disabled services are dropped together with all their sub-services.

    Type: (String -> String -> service -> list { ... })
  */
  flattenServices =
    parentPrefix: prefix: service:
    if !service.enable then
      [ ]
    else
      [
        {
          name = prefix;
          inherit parentPrefix service;
        }
      ]
      ++ concatLists (
        mapAttrsToList (subName: sub: flattenServices prefix (dash prefix subName) sub) service.services
      );

  /**
    Factory for a per-backend `configData` path module, analogous to the
    systemd implementation (`nixos/modules/system/service/systemd/config-data-path.nix`).

    `configDataPathModule { baseDir = "/etc/dinit/system-services"; }` returns
    a module that assigns `configData.<file>.path` for every service and
    recurses into sub-services.
  */
  configDataPathModule =
    { baseDir }:
    let
      setPathsModule =
        prefix:
        { lib, name, ... }:
        {
          _class = "service";
          options = {
            configData = mkOption {
              type = types.lazyAttrsOf (
                types.submodule (
                  { config, ... }:
                  {
                    config = {
                      path = lib.mkDefault "${baseDir}/${prefix}${name}/${config.name}";
                    };
                  }
                )
              );
            };
            services = mkOption {
              type = types.attrsOf (
                types.submoduleWith {
                  modules = [ (setPathsModule "${prefix}${name}-") ];
                }
              );
            };
          };
        };
    in
    setPathsModule "";

  /**
    General topological sort (Kahn's algorithm). `edges` maps each node to the
    nodes it depends on (which must come before it in the result). Nodes that
    are ready (all deps already taken) are appended in order; remaining cycles
    are broken by taking the first remaining node.

    Type: (a -> List a) -> List a -> List a
  */
  topoSort =
    edges: nodes:
    let
      step =
        acc: rest:
        if rest == [ ] then
          acc
        else
          let
            candidates = filter (n: lib.all (d: !builtins.elem d rest) (edges n)) rest;
            pick = if candidates == [ ] then builtins.head rest else builtins.head candidates;
          in
          step (acc ++ [ pick ]) (filter (n: n != pick) rest);
    in
    step [ ] nodes;
}
