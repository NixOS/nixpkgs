{ config, lib, hostPkgs, ... }:
{
  config = {
    # default pkgs for use in VMs
    _module.args.pkgs = hostPkgs;

    defaults = {
      # TODO: a module to set a shared pkgs, if options.nixpkgs.* is untouched by user (highestPrio) */
    };
  };
}
