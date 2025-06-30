{
  config,
  lib,
  options,
  ...
}:
{

  ###### interface

  options = {

    systemd.enableEmergencyMode = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = ''
        Whether to enable emergency mode, which is an
        {command}`sulogin` shell started on the console if
        mounting a filesystem fails.  Since some machines (like EC2
        instances) have no console of any kind, emergency mode doesn't
        make sense, and it's better to continue with the boot insofar
        as possible.

        For initrd emergency access, use ${options.boot.initrd.systemd.emergencyAccess} instead.
      '';
    };

  };

  ###### implementation

  config = {

    systemd.additionalUpstreamSystemUnits = lib.optionals config.systemd.enableEmergencyMode [
      "emergency.target"
      "emergency.service"
    ];

  };

}
