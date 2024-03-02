{ config, options, lib, pkgs, stdenv, ... }:
let
  cfg = config.services.pleroma;
in {
  options = {
    services.pleroma = with lib; {
      enable = mkEnableOption (lib.mdDoc "pleroma");

      package = mkPackageOption pkgs "pleroma" { };

      user = mkOption {
        type = types.str;
        default = "pleroma";
        description = lib.mdDoc "User account under which pleroma runs.";
      };

      group = mkOption {
        type = types.str;
        default = "pleroma";
        description = lib.mdDoc "Group account under which pleroma runs.";
      };

      stateDir = mkOption {
        type = types.str;
        default = "/var/lib/pleroma";
        readOnly = true;
        description = lib.mdDoc "Directory where the pleroma service will save the uploads and static files.";
      };

      configs = mkOption {
        type = with types; listOf str;
        description = lib.mdDoc ''
          Pleroma public configuration.

          This list gets appended from left to
          right into /etc/pleroma/config.exs. Elixir evaluates its
          configuration imperatively, meaning you can override a
          setting by appending a new str to this NixOS option list.

          *DO NOT STORE ANY PLEROMA SECRET
          HERE*, use
          [services.pleroma.secretConfigFile](#opt-services.pleroma.secretConfigFile)
          instead.

          This setting is going to be stored in a file part of
          the Nix store. The Nix store being world-readable, it's not
          the right place to store any secret

          Have a look to Pleroma section in the NixOS manual for more
          information.
          '';
      };

      secretConfigFile = mkOption {
        type = types.str;
        default = "/var/lib/pleroma/secrets.exs";
        description = lib.mdDoc ''
          Path to the file containing your secret pleroma configuration.

          *DO NOT POINT THIS OPTION TO THE NIX
          STORE*, the store being world-readable, it'll
          compromise all your secrets.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    users = {
      users."${cfg.user}" = {
        description = "Pleroma user";
        home = cfg.stateDir;
        group = cfg.group;
        isSystemUser = true;
      };
      groups."${cfg.group}" = {};
    };

    environment.systemPackages = [ cfg.package ];

    environment.etc."/pleroma/config.exs".text = ''
      ${lib.concatMapStrings (x: "${x}") cfg.configs}

      # The lau/tzdata library is trying to download the latest
      # timezone database in the OTP priv directory by default.
      # This directory being in the store, it's read-only.
      # Setting that up to a more appropriate location.
      config :tzdata, :data_dir, "/var/lib/pleroma/elixir_tzdata_data"

      import_config "${cfg.secretConfigFile}"
    '';

    systemd.services.pleroma = {
      description = "Pleroma social network";
      wants = [ "network-online.target" ];
      after = [ "network-online.target" "postgresql.service" ];
      wantedBy = [ "multi-user.target" ];
      restartTriggers = [ config.environment.etc."/pleroma/config.exs".source ];
      environment.RELEASE_COOKIE = "/var/lib/pleroma/.cookie";
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        Type = "exec";
        WorkingDirectory = "~";
        StateDirectory = "pleroma pleroma/static pleroma/uploads";
        StateDirectoryMode = "700";

        # Checking the conf file is there then running the database
        # migration before each service start, just in case there are
        # some pending ones.
        #
        # It's sub-optimal as we'll always run this, even if pleroma
        # has not been updated. But the no-op process is pretty fast.
        # Better be safe than sorry migration-wise.
        ExecStartPre =
          let preScript = pkgs.writers.writeBashBin "pleromaStartPre" ''
            if [ ! -f /var/lib/pleroma/.cookie ]
            then
              echo "Creating cookie file"
              dd if=/dev/urandom bs=1 count=16 | hexdump -e '16/1 "%02x"' > /var/lib/pleroma/.cookie
            fi
            ${cfg.package}/bin/pleroma_ctl migrate
          '';
          in "${preScript}/bin/pleromaStartPre";

        ExecStart = "${cfg.package}/bin/pleroma start";
        ExecStop = "${cfg.package}/bin/pleroma stop";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";

        # Systemd sandboxing directives.
        # Taken from the upstream contrib systemd service at
        # pleroma/installation/pleroma.service
        PrivateTmp = true;
        ProtectHome = true;
        ProtectSystem = "full";
        PrivateDevices = false;
        NoNewPrivileges = true;
        CapabilityBoundingSet = "~CAP_SYS_ADMIN";
      };
      # disksup requires bash
      path = [ pkgs.bash ];
    };

  };
  meta.maintainers = with lib.maintainers; [ picnoir ];
  meta.doc = ./pleroma.md;
}
