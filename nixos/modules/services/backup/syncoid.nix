{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.syncoid;
in {

    # Interface

    options.services.syncoid = {
      enable = mkEnableOption "Syncoid ZFS synchronization service";

      interval = mkOption {
        type = types.str;
        default = "hourly";
        example = "*-*-* *:15:00";
        description = ''
          Run syncoid at this interval. The default is to run hourly.

          The format is described in
          <citerefentry><refentrytitle>systemd.time</refentrytitle>
          <manvolnum>7</manvolnum></citerefentry>.
        '';
      };

      user = mkOption {
        type = types.str;
        default = "root";
        example = "backup";
        description = ''
          The user for the service. Sudo or ZFS privilege delegation must be
          configured to use a user other than root.
        '';
      };

      sshKey = mkOption {
        type = types.nullOr types.path;
        # Prevent key from being copied to store
        apply = mapNullable toString;
        default = null;
        description = ''
          SSH private key file to use to login to the remote system. Can be
          overridden in individual commands.
        '';
      };

      commonArgs = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [ "--no-sync-snap" ];
        description = ''
          Arguments to add to every syncoid command, unless disabled for that
          command. See
          <link xlink:href="https://github.com/jimsalterjrs/sanoid/#syncoid-command-line-options"/>
          for available options.
        '';
      };

      commands = mkOption {
        type = types.attrsOf (types.submodule ({ name, ... }: {
          options = {
            source = mkOption {
              type = types.str;
              example = "pool/dataset";
              description = ''
                Source ZFS dataset. Can be either local or remote. Defaults to
                the attribute name.
              '';
            };

            target = mkOption {
              type = types.str;
              example = "user@server:pool/dataset";
              description = ''
                Target ZFS dataset. Can be either local
                (<replaceable>pool/dataset</replaceable>) or remote
                (<replaceable>user@server:pool/dataset</replaceable>).
              '';
            };

            recursive = mkOption {
              type = types.bool;
              default = false;
              description = ''
                Whether to also transfer child datasets.
              '';
            };

            sshKey = mkOption {
              type = types.nullOr types.path;
              # Prevent key from being copied to store
              apply = mapNullable toString;
              description = ''
                SSH private key file to use to login to the remote system.
                Defaults to <option>services.syncoid.sshKey</option> option.
              '';
            };

            sendOptions = mkOption {
              type = types.separatedString " ";
              default = "";
              example = "Lc e";
              description = ''
                Advanced options to pass to zfs send. Options are specified
                without their leading dashes and separated by spaces.
              '';
            };

            recvOptions = mkOption {
              type = types.separatedString " ";
              default = "";
              example = "ux recordsize o compression=lz4";
              description = ''
                Advanced options to pass to zfs recv. Options are specified
                without their leading dashes and separated by spaces.
              '';
            };

            useCommonArgs = mkOption {
              type = types.bool;
              default = true;
              description = ''
                Whether to add the configured common arguments to this command.
              '';
            };

            extraArgs = mkOption {
              type = types.listOf types.str;
              default = [];
              example = [ "--sshport 2222" ];
              description = "Extra syncoid arguments for this command.";
            };
          };
          config = {
            source = mkDefault name;
            sshKey = mkDefault cfg.sshKey;
          };
        }));
        default = {};
        example."pool/test".target = "root@target:pool/test";
        description = "Syncoid commands to run.";
      };
    };

    # Implementation

    config = mkIf cfg.enable {
      systemd.services.syncoid = {
        description = "Syncoid ZFS synchronization service";
        script = concatMapStringsSep "\n" (c: lib.escapeShellArgs
          ([ "${pkgs.sanoid}/bin/syncoid" ]
            ++ (optionals c.useCommonArgs cfg.commonArgs)
            ++ (optional c.recursive "-r")
            ++ (optionals (c.sshKey != null) [ "--sshkey" c.sshKey ])
            ++ c.extraArgs
            ++ [ "--sendoptions" c.sendOptions
                 "--recvoptions" c.recvOptions
                 c.source c.target
               ])) (attrValues cfg.commands);
        after = [ "zfs.target" ];
        serviceConfig.User = cfg.user;
        startAt = cfg.interval;
      };
    };

    meta.maintainers = with maintainers; [ lopsided98 ];
  }
