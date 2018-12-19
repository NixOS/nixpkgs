{ config, lib, pkgs, ... }:

with lib;

{

  ###### interface

  options = {

    services.pfix-srsd = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = "Whether to run the postfix sender rewriting scheme daemon.";
      };

      domain = mkOption {
        description = "The domain for which to enable srs";
        type = types.str;
        example = "example.com";
      };

      secretsFile = mkOption {
        description = ''
          The secret data used to encode the SRS address.
          to generate, use a command like:
          <literal>for n in $(seq 5); do dd if=/dev/urandom count=1 bs=1024 status=none | sha256sum | sed 's/  -$//' | sed 's/^/          /'; done</literal>
        '';
        type = types.path;
        default = "/var/lib/pfix-srsd/secrets";
      };
    };
  };

  ###### implementation

  config = mkIf config.services.pfix-srsd.enable {
    environment = {
      systemPackages = [ pkgs.pfixtools ];
    };

    systemd.services."pfix-srsd" = {
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