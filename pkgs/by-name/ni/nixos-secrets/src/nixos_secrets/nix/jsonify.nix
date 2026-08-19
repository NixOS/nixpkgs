# Takes a configuration and prepares it to be consumed by the Python CLI.
#
# There's three kinds of supported configurations:
# - unevaluated NixOS configurations (will be evaluated with the target Nixpkgs
#   instance)
# - evaluated NixOS configurations (the options will be extracted from the
#   respective NixOS module)
# - evaluated secrets configurations (the script will then be a NO-OP), i.e.
#   objects already matching the secrets schema (TODO: document this)
#
# Note that this file is *not* a Nix(OS) module! This will automatically be
# evaluated by the secrets CLI.
#
# Parameters:
# - `configuration`: The thing to actually turn into a secrets configuration.
# - `phgsTarget`: the package set to use for the target system. Will fallback
#   to the package set the configuration was evaluated with (for NixOS
#   configurations) or to `pkgsDefault` otherwise.
# - `pkgsDefault`: a default for when the `pkgsTarget` is not otherwise
#   specified. Passed from the CLI.
# - `pkgsHost`: the package set to use for the host system. Will fall back to
#   the resolved package set for the target machine.
#
# People who want to write custom Nix(OS)-modules for use with the secrets CLI
# should write an accompanying `jsonify`-esque function, and pass its output to
# the CLI. As long as the output matches the secrets configuration schema (TODO:
# document that), this function will leave said output untouched and let the
# CLI do its thing.
{
  configuration,
  pkgsTarget ? null,
  pkgsHost ? null,
  pkgsDefault ? null,
}:
let
  pkgsTarget' =
    if pkgsTarget != null then
      pkgsTarget
    else if configuration._type or null == "configuration" then
      configuration.pkgs
    else if pkgsDefault != null then
      pkgsDefault
    else
      throw "Cannot infer the package set for the target machine.";

  pkgsHost' = if pkgsHost != null then pkgsHost else pkgsTarget';

  inherit (pkgsHost') lib;

  # If the configuration has been evaluated already, simply keep it that way.
  # Otherwise, evaluate it.
  cfg =
    if configuration._type or null == "configuration" then
      configuration.config.secrets
    else
      (import (pkgsTarget'.path + "/nixos/lib/eval-config.nix") {
        modules = [ configuration ];
      }).config.secrets;

  # Generator scripts might have to run on a different system from the target
  # machine's. As a result, they are not merely packages, but functions from
  # package sets to packages.
  #
  # Note that, when possible, we want to be "lazy" about building said
  # derivations. In particular, we want Nix to realise the derivation files on
  # disk, but not build them. This works pretty nicely out of the box when using
  # the .drvPath attribute of a derivation.
  #
  # Still, some people might not pass a derivation here, but instead a
  # non-top-level store-path (for example, "${pkgs.foo}/bin/goo"). We want to
  # support this as well, so we detect such paths and wrap them in a tiny proxy
  # script. This feels a bit hacky, but we couldn't find a better way to not
  # throw away the string's context when converting it to JSON (for consumption
  # from the Python side).
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
            pkgsHost'.writeScript "secrets-wrapper-script" ''
              #!/bin/sh
              exec ${forced} "$@"
            '';
      in
      drv.drvPath;
in
# We want this function to be idempotent. That is, we want running it repeatedly
# to produce the same result as only running it once. This is useful since
# advanced users might prefer to manually call this in order to override the
# various package sets involved. The Python CLI has no way of knowing whether
# that has taken place, so it runs this function by itself nonetheless, hence
# why we have to turn that into a no-op.
#
# Last but not least, as specified in the top-level comment, we also want to
# support people writing their own Nix(OS)-modules / `jsonify`-esque functions
# for use with the CLI, which this also accomplishes.
if configuration._type or null == "secrets-configuration" then
  configuration
else
  {
    _type = "secrets-configuration";

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
