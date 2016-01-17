{ config, lib, pkgs, ... }:

with lib;

let

  /* minimal secure setup:

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
        inherit description default;
        type = types.bool;
      };
    };
  };

  optionDescription = [
    (yesNoOption "anonymousUser" "anonymous_enable" false ''
      Whether to enable the anonymous FTP user.
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
      Specifies whether <option>userlistFile</option> is a list of user
      names to allow or deny access.
      The default <literal>false</literal> means whitelist/allow.
    '')
    (yesNoOption "forceLocalLoginsSSL" "force_local_logins_ssl" false ''
      Only applies if <option>sslEnable</option> is true. Non anonymous (local) users
      must use a secure SSL connection to send a password.
    '')
    (yesNoOption "forceLocalDataSSL" "force_local_data_ssl" false ''
      Only applies if <option>sslEnable</option> is true. Non anonymous (local) users
      must use a secure SSL connection for sending/receiving data on data connection.
    '')
    (yesNoOption "portPromiscuous" "port_promiscuous" false ''
      Set to YES if you want to disable the PORT security check that ensures that
      outgoing data connections can only connect to the client. Only enable if you
      know what you are doing!
    '')
    (yesNoOption "ssl_tlsv1" "ssl_tlsv1" true  '' '')
    (yesNoOption "ssl_sslv2" "ssl_sslv2" false '' '')
    (yesNoOption "ssl_sslv3" "ssl_sslv3" false '' '')
  ];

  configFile = pkgs.writeText "vsftpd.conf"
    ''
      ${concatMapStrings (x: "${x.cfgText}\n") optionDescription}
      ${optionalString (cfg.rsaCertFile != null) ''
        ssl_enable=YES
        rsa_cert_file=${cfg.rsaCertFile}
      ''}
      ${optionalString (cfg.userlistFile != null) ''
        userlist_file=${cfg.userlistFile}
      ''}
      background=YES
      listen=YES
      nopriv_user=vsftpd
      secure_chroot_dir=/var/empty
      syslog_enable=YES
      ${optionalString (pkgs.stdenv.system == "x86_64-linux") ''
        seccomp_sandbox=NO
      ''}
      anon_umask=${cfg.anonymousUmask}
    '';

in

{

  ###### interface

  options = {

    services.vsftpd = {

      enable = mkOption {
        default = false;
        description = "Whether to enable the vsftpd FTP server.";
      };

      userlist = mkOption {
        default = [];
        description = "See <option>userlistFile</option>.";
      };

      userlistFile = mkOption {
        type = types.path;
        default = pkgs.writeText "userlist" (concatMapStrings (x: "${x}\n") cfg.userlist);
        defaultText = "pkgs.writeText \"userlist\" (concatMapStrings (x: \"\${x}\n\") cfg.userlist)";
        description = ''
          Newline separated list of names to be allowed/denied if <option>userlistEnable</option>
          is <literal>true</literal>. Meaning see <option>userlistDeny</option>.

          The default is a file containing the users from <option>userlist</option>.

          If explicitely set to null userlist_file will not be set in vsftpd's config file.
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

      anonymousUmask = mkOption {
        type = types.string;
        default = "077";
        example = "002";
        description = "Anonymous write umask.";
      };

    } // (listToAttrs (catAttrs "nixosOption" optionDescription));

  };


  ###### implementation

  config = mkIf cfg.enable {

    assertions = singleton
      { assertion =
              (cfg.forceLocalLoginsSSL -> cfg.rsaCertFile != null)
          &&  (cfg.forceLocalDataSSL -> cfg.rsaCertFile != null);
        message = "vsftpd: If forceLocalLoginsSSL or forceLocalDataSSL is true then a rsaCertFile must be provided!";
      };

    users.extraUsers =
      [ { name = "vsftpd";
          uid = config.ids.uids.vsftpd;
          description = "VSFTPD user";
          home = "/homeless-shelter";
        }
      ] ++ optional cfg.anonymousUser
        { name = "ftp";
          uid = config.ids.uids.ftp;
          group = "ftp";
          description = "Anonymous FTP user";
          home = cfg.anonymousUserHome;
        };

    users.extraGroups.ftp.gid = config.ids.gids.ftp;

    # If you really have to access root via FTP use mkOverride or userlistDeny
    # = false and whitelist root
    services.vsftpd.userlist = if cfg.userlistDeny then ["root"] else [];

    systemd.services.vsftpd =
      { description = "Vsftpd Server";

        wantedBy = [ "multi-user.target" ];

        preStart =
          optionalString cfg.anonymousUser
            ''
              mkdir -p -m 555 ${cfg.anonymousUserHome}
              chown -R ftp:ftp ${cfg.anonymousUserHome}
            '';

        serviceConfig.ExecStart = "@${vsftpd}/sbin/vsftpd vsftpd ${configFile}";
        serviceConfig.Restart = "always";
        serviceConfig.Type = "forking";
      };

  };

}
