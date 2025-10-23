{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let

  /*
    minimal secure setup:

    enable = true;
    forceLocalLoginsSSL = true;
    forceLocalDataSSL = true;
    userlistDeny = false;
    localUsers = true;
    userlist = ["non-root-user" "other-non-root-user"];
    rsaCertFile = "/var/vsftpd/vsftpd.pem";
  */

  cfg = config.services.vsftpd;

  inherit (pkgs) vsftpd;

  yesNoOption = nixosName: vsftpdName: default: description: {
    cfgText = "${vsftpdName}=${if getAttr nixosName cfg then "YES" else "NO"}";

    nixosOption = {
      type = types.bool;
      name = nixosName;
      value = mkOption {
        description = description;
        inherit default;
        type = types.bool;
      };
    };
  };

  optionDescription = [
    (yesNoOption "allowWriteableChroot" "allow_writeable_chroot" false ''
      Allow the use of writeable root inside chroot().
    '')
    (yesNoOption "virtualUseLocalPrivs" "virtual_use_local_privs" false ''
      If enabled, virtual users will use the same privileges as local
      users. By default, virtual users will use the same privileges as
      anonymous users, which tends to be more restrictive (especially
      in terms of write access).
    '')
    (yesNoOption "anonymousUser" "anonymous_enable" false ''
      Whether to enable the anonymous FTP user.
    '')
    (yesNoOption "anonymousUserNoPassword" "no_anon_password" false ''
      Whether to disable the password for the anonymous FTP user.
    '')
    (yesNoOption "localUsers" "local_enable" false ''
      Whether to enable FTP for local users.
    '')
    (yesNoOption "writeEnable" "write_enable" false ''
      Whether any write activity is permitted to users.
    '')
    (yesNoOption "anonymousUploadEnable" "anon_upload_enable" false ''
      Whether any uploads are permitted to anonymous users.
    '')
    (yesNoOption "anonymousMkdirEnable" "anon_mkdir_write_enable" false ''
      Whether any uploads are permitted to anonymous users.
    '')
    (yesNoOption "chrootlocalUser" "chroot_local_user" false ''
      Whether local users are confined to their home directory.
    '')
    (yesNoOption "userlistEnable" "userlist_enable" false ''
      Whether users are included.
    '')
    (yesNoOption "userlistDeny" "userlist_deny" false ''
      Specifies whether {option}`userlistFile` is a list of user
      names to allow or deny access.
      The default `false` means whitelist/allow.
    '')
    (yesNoOption "forceLocalLoginsSSL" "force_local_logins_ssl" false ''
      Only applies if {option}`sslEnable` is true. Non anonymous (local) users
      must use a secure SSL connection to send a password.
    '')
    (yesNoOption "forceLocalDataSSL" "force_local_data_ssl" false ''
      Only applies if {option}`sslEnable` is true. Non anonymous (local) users
      must use a secure SSL connection for sending/receiving data on data connection.
    '')
    (yesNoOption "portPromiscuous" "port_promiscuous" false ''
      Set to YES if you want to disable the PORT security check that ensures that
      outgoing data connections can only connect to the client. Only enable if you
      know what you are doing!
    '')
    (yesNoOption "ssl_tlsv1" "ssl_tlsv1" true ''
      Only applies if {option}`ssl_enable` is activated. If
      enabled, this option will permit TLS v1 protocol connections.
      TLS v1 connections are preferred.
    '')
    (yesNoOption "ssl_sslv2" "ssl_sslv2" false ''
      Only applies if {option}`ssl_enable` is activated. If
      enabled, this option will permit SSL v2 protocol connections.
      TLS v1 connections are preferred.
    '')
    (yesNoOption "ssl_sslv3" "ssl_sslv3" false ''
      Only applies if {option}`ssl_enable` is activated. If
      enabled, this option will permit SSL v3 protocol connections.
      TLS v1 connections are preferred.
    '')
  ];

  configFile = pkgs.writeText "vsftpd.conf" ''
    ${concatMapStrings (x: "${x.cfgText}\n") optionDescription}
    ${optionalString (cfg.rsaCertFile != null) ''
      ssl_enable=YES
      rsa_cert_file=${cfg.rsaCertFile}
    ''}
    ${optionalString (cfg.rsaKeyFile != null) ''
      rsa_private_key_file=${cfg.rsaKeyFile}
    ''}
    ${optionalString (cfg.userlistFile != null) ''
      userlist_file=${cfg.userlistFile}
    ''}
    background=YES
    listen=NO
    listen_ipv6=YES
    nopriv_user=vsftpd
    secure_chroot_dir=/var/empty
    ${optionalString (cfg.localRoot != null) ''
      local_root=${cfg.localRoot}
    ''}
    syslog_enable=YES
    ${optionalString (pkgs.stdenv.hostPlatform.system == "x86_64-linux") ''
      seccomp_sandbox=NO
    ''}
    anon_umask=${cfg.anonymousUmask}
    ${optionalString cfg.anonymousUser ''
      anon_root=${cfg.anonymousUserHome}
    ''}
    ${optionalString cfg.enableVirtualUsers ''
      guest_enable=YES
      guest_username=vsftpd
    ''}
    pam_service_name=vsftpd
    ${cfg.extraConfig}
  '';

in

{

  ###### interface

  options = {

    services.vsftpd = {

      enable = mkEnableOption "vsftpd";

      userlist = mkOption {
        default = [ ];
        type = types.listOf types.str;
        description = "See {option}`userlistFile`.";
      };

      userlistFile = mkOption {
        type = types.path;
        default = pkgs.writeText "userlist" (concatMapStrings (x: "${x}\n") cfg.userlist);
        defaultText = literalExpression ''pkgs.writeText "userlist" (concatMapStrings (x: "''${x}\n") cfg.userlist)'';
        description = ''
          Newline separated list of names to be allowed/denied if {option}`userlistEnable`
          is `true`. Meaning see {option}`userlistDeny`.

          The default is a file containing the users from {option}`userlist`.

          If explicitly set to null userlist_file will not be set in vsftpd's config file.
        '';
      };

      enableVirtualUsers = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable the `pam_userdb`-based
          virtual user system
        '';
      };

      userDbPath = mkOption {
        type = types.nullOr types.str;
        example = "/etc/vsftpd/userDb";
        default = null;
        description = ''
          Only applies if {option}`enableVirtualUsers` is true.
          Path pointing to the `pam_userdb` user
          database used by vsftpd to authenticate the virtual users.

          This user list should be stored in the Berkeley DB database
          format.

          To generate a new user database, create a text file, add
          your users using the following format:
          ```
          user1
          password1
          user2
          password2
          ```

          You can then install `pkgs.db` to generate
          the Berkeley DB using
          ```
          db_load -T -t hash -f logins.txt userDb.db
          ```

          Caution: `pam_userdb` will automatically
          append a `.db` suffix to the filename you
          provide though this option. This option shouldn't include
          this filetype suffix.
        '';
      };

      localRoot = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "/var/www/$USER";
        description = ''
          This option represents a directory which vsftpd will try to
          change into after a local (i.e. non- anonymous) login.

          Failure is silently ignored.
        '';
      };

      anonymousUserHome = mkOption {
        type = types.path;
        default = "/home/ftp/";
        description = ''
          Directory to consider the HOME of the anonymous user.
        '';
      };

      rsaCertFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "RSA certificate file.";
      };

      rsaKeyFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "RSA private key file.";
      };

      anonymousUmask = mkOption {
        type = types.str;
        default = "077";
        example = "002";
        description = "Anonymous write umask.";
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        example = "ftpd_banner=Hello";
        description = "Extra configuration to add at the bottom of the generated configuration file.";
      };

    }
    // (listToAttrs (catAttrs "nixosOption" optionDescription));

  };

  ###### implementation

  config = mkIf cfg.enable {

    assertions = [
      {
        assertion =
          (cfg.forceLocalLoginsSSL -> cfg.rsaCertFile != null)
          && (cfg.forceLocalDataSSL -> cfg.rsaCertFile != null);
        message = "vsftpd: If forceLocalLoginsSSL or forceLocalDataSSL is true then a rsaCertFile must be provided!";
      }
      {
        assertion =
          (cfg.enableVirtualUsers -> cfg.userDbPath != null) && (cfg.enableVirtualUsers -> cfg.localUsers);
        message = "vsftpd: If enableVirtualUsers is true, you need to setup both the userDbPath and localUsers options.";
      }
    ];

    users.users = {
      "vsftpd" = {
        group = "vsftpd";
        isSystemUser = true;
        description = "VSFTPD user";
        home =
          if cfg.localRoot != null then
            cfg.localRoot # <= Necessary for virtual users.
          else
            "/homeless-shelter";
      };
    }
    // optionalAttrs cfg.anonymousUser {
      "ftp" = {
        name = "ftp";
        uid = config.ids.uids.ftp;
        group = "ftp";
        description = "Anonymous FTP user";
        home = cfg.anonymousUserHome;
      };
    };

    users.groups.vsftpd = { };
    users.groups.ftp.gid = config.ids.gids.ftp;

    # If you really have to access root via FTP use mkOverride or userlistDeny
    # = false and whitelist root
    services.vsftpd.userlist = optional cfg.userlistDeny "root";

    systemd = {
      tmpfiles.rules =
        optional cfg.anonymousUser
          #Type Path                       Mode User   Gr    Age Arg
          "d    '${builtins.toString cfg.anonymousUserHome}' 0555 'ftp'  'ftp' -   -";
      services.vsftpd = {
        description = "Vsftpd Server";

        wantedBy = [ "multi-user.target" ];

        serviceConfig.ExecStart = "@${vsftpd}/sbin/vsftpd vsftpd ${configFile}";
        serviceConfig.Restart = "always";
        serviceConfig.Type = "forking";
      };
    };

    security.pam.services.vsftpd.text = mkIf (cfg.enableVirtualUsers && cfg.userDbPath != null) ''
      auth required pam_userdb.so db=${cfg.userDbPath}
      account required pam_userdb.so db=${cfg.userDbPath}
    '';
  };
}
