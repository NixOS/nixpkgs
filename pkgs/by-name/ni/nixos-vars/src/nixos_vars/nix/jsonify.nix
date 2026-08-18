# Takes a configuration and prepares it to be consumed by the Python side.
# There's three kinds of supported configurations:
# - unevaluated NixOS configurations (will be evaluated with the target Nixpkgs
#   instance
# - evaluated NixOS configurations (the options will be extracted from the
#   respective NixOS module)
# - evaluated vars configurations (the script will then be a NOOP)
#
# Note that this is *not* a NixOS module! This will be evaluated by the vars
# CLI.
{
  configuration,
  pkgsHost ? null,
  pkgsTarget ? null,
  pkgsDefault ? null,
}:
let
  pkgsTarget' =
    if pkgsTarget != null then
      pkgsTarget
    else if configuration._type or null == "configuration" then
      configuration.pkgs
    else
      pkgsDefault;

  pkgsHost' = if pkgsHost != null then pkgsHost else pkgsTarget';

  inherit (pkgsHost') lib;

  # If the configuration has been evaluated already, simply keep it that way.
  # Otherwise, evaluate it.
  cfg =
    if configuration._type or null == "configuration" then
      configuration.config.vars
    else
      (import (pkgsTarget'.path + "/nixos/lib/eval-config.nix") {
        modules = [ configuration ];
      }).config.vars;

  evalDeferredPackage =
    pkg:
    if pkg == null then
      null
    else
      let
        forced = pkg pkgsHost';
        drv =
          if forced.type or null == "derivation" then
            forced
          else
            pkgsHost'.writeScript "vars-wrapper-script" ''
              #!/bin/sh
              exec ${forced} "$@"
            '';
      in
      drv.drvPath;
in
# Make this call idempotent
if configuration._type or null == "vars-configuration" then
  configuration
else
  {
    _type = "vars-configuration";

    promptBackends = lib.mapAttrs' (_: backend: {
      inherit (backend) name;
      value = {
        script = evalDeferredPackage backend.script;
      };
    }) cfg.promptBackends;

    prompts = lib.mapAttrs' (_: prompt: {
      inherit (prompt) name;
      value = {
        inherit (prompt)
          label
          description
          type
          backend
          ;
      };
    }) cfg.prompts;

    generatorBackends = lib.mapAttrs' (_: backend: {
      inherit (backend) name;
      value = {
        get = evalDeferredPackage backend.get;
        set = evalDeferredPackage backend.set;
        exists = evalDeferredPackage backend.exists;
        delete = evalDeferredPackage backend.delete;
        list = evalDeferredPackage backend.list;
        fixup = evalDeferredPackage backend.fixup;
        deploy.local = evalDeferredPackage backend.deploy.local;
        deploy.remote = evalDeferredPackage backend.deploy.remote;
      };
    }) cfg.generatorBackends;

    generators = lib.mapAttrs' (_: generator: {
      inherit (generator) name;
      value = {
        inherit (generator) prompts dependencies backend;
        script = evalDeferredPackage generator.script;
        files = lib.mapAttrs' (_: file: {
          inherit (file) name;
          value = {
            inherit (file) local;
          };
        }) generator.files;
      };
    }) cfg.generators;
  }
