# Takes an evaluated configuration and prepares it to be consumed by the Python
# side.
#
# The given package set needs to be the one of the current host, not the one of
# the target host! (the one of the target host is the one the config has been
# built with!)
#
# Note that this is *not* a NixOS module! This will be evaluated by the vars
# CLI.
{ config, pkgs }:
let
  inherit (pkgs) lib;
  cfg = config.vars;
  evalDeferredPackage = pkg: if pkg == null then null else (pkg pkgs).drvPath;
in
{
  prompts = {
    backends = lib.mapAttrs (_: backend: {
      run = evalDeferredPackage backend.run;
    }) cfg.promptBackends;

    prompts = lib.mapAttrs (_: prompt: {
      inherit (prompt) description type backend;
    }) cfg.prompts;
  };

  generators = {
    backends = lib.mapAttrs (_: backend: {
      get = evalDeferredPackage backend.get;
      set = evalDeferredPackage backend.set;
      exists = evalDeferredPackage backend.exists;
      delete = evalDeferredPackage backend.delete;
      list = evalDeferredPackage backend.list;
      deploy = evalDeferredPackage backend.deploy;
      deployLocal = evalDeferredPackage backend.deployLocal;
    }) cfg.generatorBackends;

    generators = lib.mapAttrs (_: generator: {
      inherit (generator) prompts dependencies backend;
      script = evalDeferredPackage generator.run;
      files = lib.mapAttrs (_: file: {
        inherit (file) deploy secret;
      }) generator.files;
    }) cfg.generators;
  };
}
