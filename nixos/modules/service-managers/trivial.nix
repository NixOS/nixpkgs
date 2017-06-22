{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.trivial-services;

  serviceModule.options = {
    script = mkOption {
      type = types.lines;
      description = "Shell commands executed as the service's main process.";
    };

    environment = mkOption {
      default = {};
      type = types.attrs; # FIXME
      example = { PATH = "/foo/bar/bin"; LANG = "nl_NL.UTF-8"; };
      description = "Environment variables passed to the service's processes.";
    };
  };

  launcher = name: value: pkgs.writeScript name ''
    #!${pkgs.stdenv.shell} -eu

    ${pkgs.writeScript "${name}-entry" value.script}
  '';
in {
  options.trivial-services = mkOption {
    default = {};
    type = with types; attrsOf (types.submodule serviceModule);
    description = "Definition of trivial services";
  };

  config.system.build.toplevel-trivial = lib.mapAttrs launcher cfg;
}
