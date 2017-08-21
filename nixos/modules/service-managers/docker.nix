{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.docker-containers;

  containerModule = {
    script = mkOption {
      type = types.lines;
      description = "Shell commands executed as the service's main process.";
    };
  };

  toContainer = name: value: pkgs.dockerTools.buildImage {
    inherit name;
    config = {
      Cmd = [ value.script ];
    };
  };
in {
  options.docker-containers = mkOption {
    default = {};
    type = with types; attrsOf (types.submodule containerModule);
    description = "Definition of docker containers";
  };

  config.system.build.toplevel-docker = lib.mapAttrs toContainer cfg;
}
