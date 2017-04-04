{ config, lib, pkgs, ... }:
{
  options = {
    ec2 = {
      hvm = lib.mkOption {
        default = false;
        internal = true;
        description = ''
          Whether the EC2 instance is a HVM instance.
        '';
      };
    };
  };

  config = {
    assertions = [
      { assertion = config.ec2.hvm;
        message = "Paravirtualized EC2 instances are no longer supported.";
      }
    ];
  };
}
