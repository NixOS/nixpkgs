{ config, lib, ... }:

with lib;

{

  ###### interface

  options = {

    systemd.enableEmergencyMode = mkOption {
      default = true;
      type = types.bool;
      description = lib.mdDoc ''
        Whether to enable emergency mode, which is an
        {command}`sulogin` shell started on the console if
        mounting a filesystem fails.  Since some machines (like EC2
        instances) have no console of any kind, emergency mode doesn't
        make sense, and it's better to continue with the boot insofar
        as possible.
      '';
    };

  };

  ###### implementation

  config = {

    systemd.additionalUpstreamSystemUnits = optionals
      config.systemd.enableEmergencyMode [
        "emergency.target" "emergency.service"
      ];

  };

}
