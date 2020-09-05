{ config, lib, pkgs, ... }:

let cfg = config.services.step-ca;

in {
  options = {
    services.step-ca = {
      enable = lib.mkEnableOption "Step CA PKI Server";
      name = lib.mkOption {
        type = lib.types.str;
        default = "SmallStep";
        description = "Name of your CA.";
      };
      hostname = lib.mkOption {
        type = lib.types.str;
        default = "localhost";
        description = "Hostname/FQDN of your CA.";
      };
      address = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        example = "0.0.0.0";
        description = "The address the CA will listen at.";
      };
      port = lib.mkOption {
        type = lib.types.port;
        default = 8443;
        description = "Port to listen on.";
      };
      passwordFile = lib.mkOption {
        type = lib.types.path;
        default = null;
        example = "/run/keys/smallstep-password";
        description = "Path to file containing password of your first provisioner.";
      };
      provisioner = lib.mkOption {
        type = lib.types.str;
        default = "you@smallstep.com";
        description = "The name of the first provisioner.";
      };
      acmeProvisioner = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "acme";
        description = "Optionally create an acme provider. The resulting acme url is https://{hostname}:{port}/acme/{acmeProvisioner}/directory";
      };
      rootFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = ''
          The path of an existing PEM file to be used as the root certificate authority.
          You can generate one using e.g `step certificate create "MyCompany" root-ca.crt root-ca.key --profile root-ca --no-password --insecure` from the `step-cli` package.
          Only use this for development as the ca key is not protected with a password.
          It seems like step-ca ignores the passwordFile parameter so you can't use a key with a password.
          This should probably be reported as a bug. https://github.com/smallstep/cli/issues/220'';
      };
      keyFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "The path of an existing key file of the root certificate authority.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.step-ca = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      path = [ pkgs.step-ca pkgs.step-cli ];
      environment = { STEPPATH = "/var/lib/step-ca"; HOME = "/var/lib/step-ca"; };
      script = ''
        if [ ! -f "$STATE_DIRECTORY/ca-is-init" ]; then
          step ca init \
            --ssh \
            --name ${cfg.name} \
            --dns ${cfg.hostname} \
            --address ${cfg.address}:${toString cfg.port} \
            --provisioner ${cfg.provisioner} \
            --password-file ${cfg.passwordFile} \
            ${lib.optionalString (cfg.rootFile != null) " --root=${cfg.rootFile} "} \
            ${lib.optionalString (cfg.keyFile != null) " --key=${cfg.keyFile} "}
          ${lib.optionalString (cfg.acmeProvisioner != null) "step ca provisioner add ${cfg.acmeProvisioner} --type ACME"}
          touch $STATE_DIRECTORY/ca-is-init
        fi
        step-ca $STEPPATH/config/ca.json --password-file ${cfg.passwordFile}
      '';
      serviceConfig = {
        Type = "simple";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        Restart = "on-failure";
        StateDirectory = "step-ca";

        ProtectProc = "invisible";
        ProcSubset = "pid";
        CapabilityBoundingSet = "CAP_NET_BIND_SERVICE";
        AmbientCapabilities = "CAP_NET_BIND_SERVICE";
        NoNewPrivileges = true;
        ProtectSystem = "full";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" "AF_UNIX" ];
        RestrictNamespaces = true;
        LockPersonality = true;
        RestrictRealtime = true;
        RestrictSUIDSGID= true;
        RemoveIPC = true;
        SystemCallFilter = "~@clock @debug @module @mount @raw-io @reboot @swap @privileged @resources @cpu-emulation @obsolete";
        SystemCallArchitectures = "native";
        MemoryDenyWriteExecute = true;
        DynamicUser = true;
      };
    };
  };
}
