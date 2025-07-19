#!/usr/bin/env -S nix-instantiate --eval --strict --json
/**
  This script evaluates by default the 'meta.maintainers' and `meta.teams` of the target nixos module file and prints it as json.
  Pipe the output through `jq '.maintainers + [.teams[].members[]] | .[] | .github' -r` to retrieve github user names
  This script is a best-effort evaluation and makes no guarantee of being able to extract the maintainers from all files.
  The only files we require to not cause an evaluation failure are the ones listed in `nixos/modules/module-list.nix`

  Usage:

    ./ci/eval/compare/get-nixos-module-maintainers.nix --arg moduleFname nixos/modules/<SOME_MODULE>
  or
    ./ci/eval/compare/get-nixos-module-maintainers.nix --arg moduleFname nixos/modules/<SOME_MODULE> | jq '.maintainers + [.teams[].members[]] | .[] | .github' -r
*/

{
  pkgs ? import ../../../. { },
  lib ? pkgs.lib,
  # path to the nixos module to eval
  moduleFname,
  # change this if you want to retrieve something other than .meta.maintainers/teams
  attrGetter ? module: {
    maintainers = module.config.meta.maintainers or module.meta.maintainers or [ ];
    teams = module.config.meta.teams or module.meta.teams or [ ];
  },
}:

let
  module = (
    # This evaluator relies heavily on lazy-eval,
    # and is loosely based on nixos/lib/eval-config.nix
    lib.fix (
      config:
      let
        moduleFunc = import moduleFname;
        inputs = {
          inherit config pkgs lib;
          modulesPath = ./nixos/modules;
          options = config.options or { };
          utils = import nixos/lib/utils.nix { inherit lib config pkgs; };
          modules = [ ];
          baseModules = [ ];
          extraModules = [ ];
          specialArgs = { };
          inherit (pkgs) buildEnv;
        };
      in
      if !lib.isFunction moduleFunc then
        moduleFunc
      else
        # The lib.intersectAttrs filtering also enable evaluating many 'runTest'-based nixos tests.
        # Missing inputs become either "true" or "false" (i.e. the output from lib.functionArgs)
        moduleFunc (lib.functionArgs moduleFunc // lib.intersectAttrs (lib.functionArgs moduleFunc) inputs)
    )
  );
in
attrGetter module
