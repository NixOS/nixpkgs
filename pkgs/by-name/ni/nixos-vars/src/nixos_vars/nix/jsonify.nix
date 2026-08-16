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
  config,
  pkgsHost ? null,
  pkgsTarget ? null,
}:
let
  pkgsTarget' =
    if pkgsTarget != null then
      pkgsTarget
    else if config._type or null == "configuration" then
      config.pkgs
    else
      import <nixpkgs> { };

  pkgsHost' = if pkgsHost != null then pkgsHost else pkgsTarget';

  inherit (pkgsHost') lib;

  # If the configuration has been evaluated already, simply keep it that way.
  # Otherwise, evaluate it.
  cfg =
    if config._type or null == "configuration" then
      config.config.vars
    else
      (import (pkgsTarget'.path + "/nixos/lib/eval-config.nix") {
        modules = [ config ];
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
if config._type or null == "vars-configuration" then
  config
else
  {
    _type = "vars-configuration";

    promptBackends = lib.mapAttrs (_: backend: {
      script = evalDeferredPackage backend.script;
    }) cfg.promptBackends;

    prompts = lib.mapAttrs (_: prompt: {
      inherit (prompt)
        label
        description
        type
        backend
        ;
    }) cfg.prompts;

    generatorBackends = lib.mapAttrs (_: backend: {
      get = evalDeferredPackage backend.get;
      set = evalDeferredPackage backend.set;
      exists = evalDeferredPackage backend.exists;
      delete = evalDeferredPackage backend.delete;
      list = evalDeferredPackage backend.list;
      fixup = evalDeferredPackage backend.fixup;
      deploy = evalDeferredPackage backend.deploy;
      deployLocal = evalDeferredPackage backend.deployLocal;
    }) cfg.generatorBackends;

    generators = lib.mapAttrs (_: generator: {
      inherit (generator) prompts dependencies backend;
      script = evalDeferredPackage generator.script;
      files = lib.mapAttrs (_: file: {
        inherit (file) name local;
      }) generator.files;
    }) cfg.generators;
  }
