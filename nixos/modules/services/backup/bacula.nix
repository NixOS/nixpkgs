{
  config,
  lib,
  pkgs,
  ...
}:

# TODO: test configuration when building nixexpr (use -t parameter)
# TODO: support sqlite3 (it's deprecate?) and mysql

let
  inherit (lib)
    concatStringsSep
    literalExpression
    mapAttrsToList
    mkIf
    mkOption
    optional
    optionalString
    types
    ;
  libDir = "/var/lib/bacula";

  yes_no = bool: if bool then "yes" else "no";
  tls_conf =
    tls_cfg:
    optionalString tls_cfg.enable (
      concatStringsSep "\n" (
        [ "TLS Enable = yes;" ]
        ++ optional (tls_cfg.require != null) "TLS Require = ${yes_no tls_cfg.require};"
        ++ optional (tls_cfg.certificate != null) ''TLS Certificate = "${tls_cfg.certificate}";''
        ++ [ ''TLS Key = "${tls_cfg.key}";'' ]
        ++ optional (tls_cfg.verifyPeer != null) "TLS Verify Peer = ${yes_no tls_cfg.verifyPeer};"
        ++ optional (
          tls_cfg.allowedCN != [ ]
        ) "TLS Allowed CN = ${concatStringsSep " " (tls_cfg.allowedCN)};"
        ++ optional (
          tls_cfg.caCertificateFile != null
        ) ''TLS CA Certificate File = "${tls_cfg.caCertificateFile}";''
      )
    );

  fd_cfg = config.services.bacula-fd;
  fd_conf = pkgs.writeText "bacula-fd.conf" ''
    Client {
      Name = "${fd_cfg.name}";
      FDPort = ${toString fd_cfg.port};
      WorkingDirectory = ${libDir};
      Pid Directory = /run;
      ${fd_cfg.extraClientConfig}
      ${tls_conf fd_cfg.tls}
    }

    ${concatStringsSep "\n" (
      mapAttrsToList (name: value: ''
        Director {
          Name = "${name}";
          Password = ${value.password};
          Monitor = ${value.monitor};
          ${tls_conf value.tls}
        }
      '') fd_cfg.director
    )}

    Messages {
      Name = Standard;
      syslog = all, !skipped, !restored
      ${fd_cfg.extraMessagesConfig}
    }
  '';

  sd_cfg = config.services.bacula-sd;
  sd_conf = pkgs.writeText "bacula-sd.conf" ''
    Storage {
      Name = "${sd_cfg.name}";
      SDPort = ${toString sd_cfg.port};
      WorkingDirectory = ${libDir};
      Pid Directory = /run;
      ${sd_cfg.extraStorageConfig}
      ${tls_conf sd_cfg.tls}
    }

    ${concatStringsSep "\n" (
      mapAttrsToList (name: value: ''
        Autochanger {
          Name = "${name}";
          Device = ${concatStringsSep ", " (map (a: "\"${a}\"") value.devices)};
          Changer Device =  ${value.changerDevice};
          Changer Command = ${value.changerCommand};
          ${value.extraAutochangerConfig}
        }
      '') sd_cfg.autochanger
    )}

    ${concatStringsSep "\n" (
      mapAttrsToList (name: value: ''
        Device {
          Name = "${name}";
          Archive Device = ${value.archiveDevice};
          Media Type = ${value.mediaType};
          ${value.extraDeviceConfig}
        }
      '') sd_cfg.device
    )}

    ${concatStringsSep "\n" (
      mapAttrsToList (name: value: ''
        Director {
          Name = "${name}";
          Password = ${value.password};
          Monitor = ${value.monitor};
          ${tls_conf value.tls}
        }
      '') sd_cfg.director
    )}

    Messages {
      Name = Standard;
      syslog = all, !skipped, !restored
      ${sd_cfg.extraMessagesConfig}
    }
  '';

  dir_cfg = config.services.bacula-dir;
  dir_conf = pkgs.writeText "bacula-dir.conf" ''
    Director {
      Name = "${dir_cfg.name}";
      Password = ${dir_cfg.password};
      DirPort = ${toString dir_cfg.port};
      Working Directory = ${libDir};
      Pid Directory = /run/;
      QueryFile = ${pkgs.bacula}/etc/query.sql;
      ${tls_conf dir_cfg.tls}
      ${dir_cfg.extraDirectorConfig}
    }

    Catalog {
      Name = PostgreSQL;
      dbname = bacula;
      user = bacula;
    }

    Messages {
      Name = Standard;
      syslog = all, !skipped, !restored
      ${dir_cfg.extraMessagesConfig}
    }

    ${dir_cfg.extraConfig}
  '';

  linkOption =
    name: destination: "[${name}](#opt-${builtins.replaceStrings [ "<" ">" ] [ "_" "_" ] destination})";
  tlsLink =
    destination: submodulePath:
    linkOption "${submodulePath}.${destination}" "${submodulePath}.${destination}";

  tlsOptions =
    submodulePath:
    { ... }:
    {
      options = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Specifies if TLS should be enabled.
            If this set to `false` TLS will be completely disabled, even if ${tlsLink "tls.require" submodulePath} is true.
          '';
        };
        require = mkOption {
          type = types.nullOr types.bool;
          default = null;
          description = ''
            Require TLS or TLS-PSK encryption.
            This directive is ignored unless one of ${tlsLink "tls.enable" submodulePath} is true or TLS PSK Enable is set to `yes`.
            If TLS is not required while TLS or TLS-PSK are enabled, then the Bacula component
            will connect with other components either with or without TLS or TLS-PSK

            If ${tlsLink "tls.enable" submodulePath} or TLS-PSK is enabled and TLS is required, then the Bacula
            component will refuse any connection request that does not use TLS.
          '';
        };
        certificate = mkOption {
          type = types.nullOr types.path;
          default = null;
          description = ''
            The full path to the PEM encoded TLS certificate.
            It will be used as either a client or server certificate,
            depending on the connection direction.
            This directive is required in a server context, but it may
            not be specified in a client context if ${tlsLink "tls.verifyPeer" submodulePath} is
            `false` in the corresponding server context.
          '';
        };
        key = mkOption {
          type = types.path;
          description = ''
            The path of a PEM encoded TLS private key.
            It must correspond to the TLS certificate.
          '';
        };
        verifyPeer = mkOption {
          type = types.nullOr types.bool;
          default = null;
          description = ''
            Verify peer certificate.
            Instructs server to request and verify the client's X.509 certificate.
            Any client certificate signed by a known-CA will be accepted.
            Additionally, the client's X509 certificate Common Name must meet the value of the Address directive.
            If ${tlsLink "tls.allowedCN" submodulePath} is used,
            the client's x509 certificate Common Name must also correspond to
            one of the CN specified in the ${tlsLink "tls.allowedCN" submodulePath} directive.
            This directive is valid only for a server and not in client context.

            Standard from Bacula is `true`.
          '';
        };
        allowedCN = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = ''
            Common name attribute of allowed peer certificates.
            This directive is valid for a server and in a client context.
            If this directive is specified, the peer certificate will be verified against this list.
            In the case this directive is configured on a server side, the allowed
            CN list will not be checked if ${tlsLink "tls.verifyPeer" submodulePath} is false.
          '';
        };
        caCertificateFile = mkOption {
          type = types.nullOr types.path;
          default = null;
          description = ''
            The path specifying a PEM encoded TLS CA certificate(s).
            Multiple certificates are permitted in the file.
            One of TLS CA Certificate File or TLS CA Certificate Dir are required in a server context, unless
            ${tlsLink "tls.verifyPeer" submodulePath} is false, and are always required in a client context.
          '';
        };
      };
    };

  directorOptions =
    submodulePath:
    { ... }:
    {
      options = {
        password = mkOption {
          type = types.str;
          # TODO: required?
          description = ''
            Specifies the password that must be supplied for the default Bacula
            Console to be authorized. The same password must appear in the
            Director resource of the Console configuration file. For added
            security, the password is never passed across the network but instead
            a challenge response hash code created with the password. This
            directive is required. If you have either /dev/random or bc on your
            machine, Bacula will generate a random password during the
            configuration process, otherwise it will be left blank and you must
            manually supply it.

            The password is plain text. It is not generated through any special
            process but as noted above, it is better to use random text for
            security reasons.
          '';
        };

        monitor = mkOption {
          type = types.enum [
            "no"
            "yes"
          ];
          default = "no";
          example = "yes";
          description = ''
            If Monitor is set to `no`, this director will have
            full access to this Storage daemon. If Monitor is set to
            `yes`, this director will only be able to fetch the
            current status of this Storage daemon.

            Please note that if this director is being used by a Monitor, we
            highly recommend to set this directive to yes to avoid serious
            security problems.
          '';
        };

        tls = mkOption {
          type = types.submodule (tlsOptions "${submodulePath}.director.<name>");
          description = ''
            TLS Options for the Director in this Configuration.
          '';
        };
      };
    };

  autochangerOptions =
    { ... }:
    {
      options = {
        changerDevice = mkOption {
          type = types.str;
          description = ''
            The specified name-string must be the generic SCSI device name of the
            autochanger that corresponds to the normal read/write Archive Device
            specified in the Device resource. This generic SCSI device name
            should be specified if you have an autochanger or if you have a
            standard tape drive and want to use the Alert Command (see below).
            For example, on Linux systems, for an Archive Device name of
            `/dev/nst0`, you would specify
            `/dev/sg0` for the Changer Device name.  Depending
            on your exact configuration, and the number of autochangers or the
            type of autochanger, what you specify here can vary. This directive
            is optional. See the Using AutochangersAutochangersChapter chapter of
            this manual for more details of using this and the following
            autochanger directives.
          '';
        };

        changerCommand = mkOption {
          type = types.str;
          description = ''
            The name-string specifies an external program to be called that will
            automatically change volumes as required by Bacula. Normally, this
            directive will be specified only in the AutoChanger resource, which
            is then used for all devices. However, you may also specify the
            different Changer Command in each Device resource. Most frequently,
            you will specify the Bacula supplied mtx-changer script as follows:

            `"/path/mtx-changer %c %o %S %a %d"`

            and you will install the mtx on your system (found in the depkgs
            release). An example of this command is in the default bacula-sd.conf
            file. For more details on the substitution characters that may be
            specified to configure your autochanger please see the
            AutochangersAutochangersChapter chapter of this manual. For FreeBSD
            users, you might want to see one of the several chio scripts in
            examples/autochangers.
          '';
          default = "/etc/bacula/mtx-changer %c %o %S %a %d";
        };

        devices = mkOption {
          description = "";
          type = types.listOf types.str;
        };

        extraAutochangerConfig = mkOption {
          default = "";
          type = types.lines;
          description = ''
            Extra configuration to be passed in Autochanger directive.
          '';
          example = ''

          '';
        };
      };
    };

  deviceOptions =
    { ... }:
    {
      options = {
        archiveDevice = mkOption {
          # TODO: required?
          type = types.str;
          description = ''
            The specified name-string gives the system file name of the storage
            device managed by this storage daemon. This will usually be the
            device file name of a removable storage device (tape drive), for
            example `/dev/nst0` or
            `/dev/rmt/0mbn`. For a DVD-writer, it will be for
            example `/dev/hdc`. It may also be a directory name
            if you are archiving to disk storage. In this case, you must supply
            the full absolute path to the directory. When specifying a tape
            device, it is preferable that the "non-rewind" variant of the device
            file name be given.
          '';
        };

        mediaType = mkOption {
          # TODO: required?
          type = types.str;
          description = ''
            The specified name-string names the type of media supported by this
            device, for example, `DLT7000`. Media type names are
            arbitrary in that you set them to anything you want, but they must be
            known to the volume database to keep track of which storage daemons
            can read which volumes. In general, each different storage type
            should have a unique Media Type associated with it. The same
            name-string must appear in the appropriate Storage resource
            definition in the Director's configuration file.

            Even though the names you assign are arbitrary (i.e. you choose the
            name you want), you should take care in specifying them because the
            Media Type is used to determine which storage device Bacula will
            select during restore. Thus you should probably use the same Media
            Type specification for all drives where the Media can be freely
            interchanged. This is not generally an issue if you have a single
            Storage daemon, but it is with multiple Storage daemons, especially
            if they have incompatible media.

            For example, if you specify a Media Type of `DDS-4`
            then during the restore, Bacula will be able to choose any Storage
            Daemon that handles `DDS-4`. If you have an
            autochanger, you might want to name the Media Type in a way that is
            unique to the autochanger, unless you wish to possibly use the
            Volumes in other drives. You should also ensure to have unique Media
            Type names if the Media is not compatible between drives. This
            specification is required for all devices.

            In addition, if you are using disk storage, each Device resource will
            generally have a different mount point or directory. In order for
            Bacula to select the correct Device resource, each one must have a
            unique Media Type.
          '';
        };

        extraDeviceConfig = mkOption {
          default = "";
          type = types.lines;
          description = ''
            Extra configuration to be passed in Device directive.
          '';
          example = ''
            LabelMedia = yes
            Random Access = no
            AutomaticMount = no
            RemovableMedia = no
            MaximumOpenWait = 60
            AlwaysOpen = no
          '';
        };
      };
    };

in
{
  options = {
    services.bacula-fd = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable the Bacula File Daemon.
        '';
      };

      name = mkOption {
        default = "${config.networking.hostName}-fd";
        defaultText = literalExpression ''"''${config.networking.hostName}-fd"'';
        type = types.str;
        description = ''
          The client name that must be used by the Director when connecting.
          Generally, it is a good idea to use a name related to the machine so
          that error messages can be easily identified if you have multiple
          Clients. This directive is required.
        '';
      };

      port = mkOption {
        default = 9102;
        type = types.port;
        description = ''
          This specifies the port number on which the Client listens for
          Director connections. It must agree with the FDPort specified in
          the Client resource of the Director's configuration file.
        '';
      };

      director = mkOption {
        default = { };
        description = ''
          This option defines director resources in Bacula File Daemon.
        '';
        type = types.attrsOf (types.submodule (directorOptions "services.bacula-fd"));
      };

      tls = mkOption {
        type = types.submodule (tlsOptions "services.bacula-fd");
        default = { };
        description = ''
          TLS Options for the File Daemon.
          Important notice: The backup won't be encrypted.
        '';
      };

      extraClientConfig = mkOption {
        default = "";
        type = types.lines;
        description = ''
          Extra configuration to be passed in Client directive.
        '';
        example = ''
          Maximum Concurrent Jobs = 20;
          Heartbeat Interval = 30;
        '';
      };

      extraMessagesConfig = mkOption {
        default = "";
        type = types.lines;
        description = ''
          Extra configuration to be passed in Messages directive.
        '';
        example = ''
          console = all
        '';
      };
    };

    services.bacula-sd = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable Bacula Storage Daemon.
        '';
      };

      name = mkOption {
        default = "${config.networking.hostName}-sd";
        defaultText = literalExpression ''"''${config.networking.hostName}-sd"'';
        type = types.str;
        description = ''
          Specifies the Name of the Storage daemon.
        '';
      };

      port = mkOption {
        default = 9103;
        type = types.port;
        description = ''
          Specifies port number on which the Storage daemon listens for
          Director connections.
        '';
      };

      director = mkOption {
        default = { };
        description = ''
          This option defines Director resources in Bacula Storage Daemon.
        '';
        type = types.attrsOf (types.submodule (directorOptions "services.bacula-sd"));
      };

      device = mkOption {
        default = { };
        description = ''
          This option defines Device resources in Bacula Storage Daemon.
        '';
        type = types.attrsOf (types.submodule deviceOptions);
      };

      autochanger = mkOption {
        default = { };
        description = ''
          This option defines Autochanger resources in Bacula Storage Daemon.
        '';
        type = types.attrsOf (types.submodule autochangerOptions);
      };

      extraStorageConfig = mkOption {
        default = "";
        type = types.lines;
        description = ''
          Extra configuration to be passed in Storage directive.
        '';
        example = ''
          Maximum Concurrent Jobs = 20;
          Heartbeat Interval = 30;
        '';
      };

      extraMessagesConfig = mkOption {
        default = "";
        type = types.lines;
        description = ''
          Extra configuration to be passed in Messages directive.
        '';
        example = ''
          console = all
        '';
      };
      tls = mkOption {
        type = types.submodule (tlsOptions "services.bacula-sd");
        default = { };
        description = ''
          TLS Options for the Storage Daemon.
          Important notice: The backup won't be encrypted.
        '';
      };

    };

    services.bacula-dir = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable Bacula Director Daemon.
        '';
      };

      name = mkOption {
        default = "${config.networking.hostName}-dir";
        defaultText = literalExpression ''"''${config.networking.hostName}-dir"'';
        type = types.str;
        description = ''
          The director name used by the system administrator. This directive is
          required.
        '';
      };

      port = mkOption {
        default = 9101;
        type = types.port;
        description = ''
          Specify the port (a positive integer) on which the Director daemon
          will listen for Bacula Console connections. This same port number
          must be specified in the Director resource of the Console
          configuration file. The default is 9101, so normally this directive
          need not be specified. This directive should not be used if you
          specify DirAddresses (N.B plural) directive.
        '';
      };

      password = mkOption {
        # TODO: required?
        type = types.str;
        description = ''
          Specifies the password that must be supplied for a Director.
        '';
      };

      extraMessagesConfig = mkOption {
        default = "";
        type = types.lines;
        description = ''
          Extra configuration to be passed in Messages directive.
        '';
        example = ''
          console = all
        '';
      };

      extraDirectorConfig = mkOption {
        default = "";
        type = types.lines;
        description = ''
          Extra configuration to be passed in Director directive.
        '';
        example = ''
          Maximum Concurrent Jobs = 20;
          Heartbeat Interval = 30;
        '';
      };

      extraConfig = mkOption {
        default = "";
        type = types.lines;
        description = ''
          Extra configuration for Bacula Director Daemon.
        '';
        example = ''
          TODO
        '';
      };

      tls = mkOption {
        type = types.submodule (tlsOptions "services.bacula-dir");
        default = { };
        description = ''
          TLS Options for the Director.
          Important notice: The backup won't be encrypted.
        '';
      };
    };
  };

  config = mkIf (fd_cfg.enable || sd_cfg.enable || dir_cfg.enable) {
    systemd.slices.system-bacula = {
      description = "Bacula Backup System Slice";
      documentation = [
        "man:bacula(8)"
        "https://www.bacula.org/"
      ];
    };

    systemd.services.bacula-fd = mkIf fd_cfg.enable {
      after = [ "network.target" ];
      description = "Bacula File Daemon";
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.bacula ];
      serviceConfig = {
        ExecStart = "${pkgs.bacula}/sbin/bacula-fd -f -u root -g bacula -c ${fd_conf}";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        LogsDirectory = "bacula";
        StateDirectory = "bacula";
        Slice = "system-bacula.slice";
      };
    };

    systemd.services.bacula-sd = mkIf sd_cfg.enable {
      after = [ "network.target" ];
      description = "Bacula Storage Daemon";
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.bacula ];
      serviceConfig = {
        ExecStart = "${pkgs.bacula}/sbin/bacula-sd -f -u bacula -g bacula -c ${sd_conf}";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        LogsDirectory = "bacula";
        StateDirectory = "bacula";
        Slice = "system-bacula.slice";
      };
    };

    services.postgresql.enable = lib.mkIf dir_cfg.enable true;

    systemd.services.bacula-dir = mkIf dir_cfg.enable {
      after = [
        "network.target"
        "postgresql.service"
      ];
      description = "Bacula Director Daemon";
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.bacula ];
      serviceConfig = {
        ExecStart = "${pkgs.bacula}/sbin/bacula-dir -f -u bacula -g bacula -c ${dir_conf}";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        LogsDirectory = "bacula";
        StateDirectory = "bacula";
        Slice = "system-bacula.slice";
      };
      preStart = ''
        if ! test -e "${libDir}/db-created"; then
            ${pkgs.postgresql}/bin/createuser --no-superuser --no-createdb --no-createrole bacula
            #${pkgs.postgresql}/bin/createdb --owner bacula bacula

            # populate DB
            ${pkgs.bacula}/etc/create_bacula_database postgresql
            ${pkgs.bacula}/etc/make_bacula_tables postgresql
            ${pkgs.bacula}/etc/grant_bacula_privileges postgresql
            touch "${libDir}/db-created"
        else
            ${pkgs.bacula}/etc/update_bacula_tables postgresql || true
        fi
      '';
    };

    environment.systemPackages = [ pkgs.bacula ];

    users.users.bacula = {
      group = "bacula";
      uid = config.ids.uids.bacula;
      home = "${libDir}";
      createHome = true;
      description = "Bacula Daemons user";
      shell = "${pkgs.bash}/bin/bash";
    };

    users.groups.bacula.gid = config.ids.gids.bacula;
  };
}
