{
  config,
  lib,
  pkgs,
  ...
}:
{

  ###### interface

  options = {

    services.pfix-srsd = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to run the postfix sender rewriting scheme daemon.";
      };

      domain = lib.mkOption {
        description = "The domain for which to enable srs";
        type = lib.types.str;
        example = "example.com";
      };

      secretsFile = lib.mkOption {
        description = ''
          The secret data used to encode the SRS address.
          to generate, use a command like:
          `for n in $(seq 5); do dd if=/dev/urandom count=1 bs=1024 status=none | sha256sum | sed 's/  -$//' | sed 's/^/          /'; done`
        '';
        type = lib.types.path;
        default = "/var/lib/pfix-srsd/secrets";
      };
    };
  };

  ###### implementation

  config = lib.mkIf config.services.pfix-srsd.enable {
    environment = {
      systemPackages = [ pkgs.pfixtools ];
    };

    systemd.services.pfix-srsd = {
      description = "Postfix sender rewriting scheme daemon";
      before = [ "postfix.service" ];
      #note that we use requires rather than wants because postfix
      #is unable to process (almost) all mail without srsd
      requiredBy = [ "postfix.service" ];
      serviceConfig = {
        Type = "forking";
        PIDFile = "/run/pfix-srsd.pid";
        ExecStart = "${pkgs.pfixtools}/bin/pfix-srsd -p /run/pfix-srsd.pid -I ${config.services.pfix-srsd.domain} ${config.services.pfix-srsd.secretsFile}";
      };
    };
  };
}
