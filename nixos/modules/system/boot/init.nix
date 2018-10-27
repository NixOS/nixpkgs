{ config, lib, ... }:

{
  options = with lib; {
    system.init = {
      extraBaseSystemAttrs = mkOption {
        type = types.attrsOf types.path;
        default = {};
        internal = true;
        description = ''
          Extra environment variables to pass to baseSystem builder
        '';
      };

      extraSystemBuilderCmds = mkOption {
        type = types.lines;
        internal = true;
        description = ''
          A set of commands to be run before the other
          extraSystemBuilderCmds, meant to initialize the init system
        '';
      };
    };
  };

  config = { };
}
