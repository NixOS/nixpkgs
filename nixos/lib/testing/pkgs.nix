{
  config,
  lib,
  hostPkgs,
  ...
}:
{
  config = {
    # default pkgs for use in VMs
    _module.args.pkgs =
      # TODO: deprecate it everywhere; not just on darwin. Throw on darwin?
      lib.warnIf hostPkgs.stdenv.hostPlatform.isDarwin
        "Do not use the `pkgs` module argument in tests you want to run on darwin. It is ambiguous, and many tests are broken because of it. If you need to use a package on the VM host, use `hostPkgs`. Otherwise, use `config.node.pkgs`, or `config.nodes.<name>.nixpkgs.pkgs`."
        hostPkgs;

    defaults = {
      # TODO: a module to set a shared pkgs, if options.nixpkgs.* is untouched by user (highestPrio) */
    };
  };
}
