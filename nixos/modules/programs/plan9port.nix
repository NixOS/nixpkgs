{ config, lib, pkgs, ... }:

with lib;
{
  options.programs.plan9port = {
    enable = mkOption {
      description = ''
        Whether to make Plan 9 from User Space available from the $PLAN9
        environmental variable. The Plan 9 programs can be then be added to a
        shell environment via the <command>export PATH=$PATH:$PLAN9/bin</command>
        command. Be advised that Plan9port comes with many programs having the
        same name and function as UNIX utilities but incompatible option flags,
        so the order in which the PATH variable is structured is important!
      '';
      default = false;
      type = types.bool;
    };
  };

  config = mkIf config.programs.plan9port.enable {
    environment.sessionVariables.PLAN9 = "${pkgs.plan9port}/plan9";
  };
}
