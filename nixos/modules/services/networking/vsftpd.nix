{ config, pkgs, ... }:

with pkgs.lib;

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
    (yesNoOption "ssl_tlsv1" "ssl_tlsv1" true  '' '')
    (yesNoOption "ssl_sslv2" "ssl_sslv2" false '' '')
    (yesNoOption "ssl_sslv3" "ssl_sslv3" false '' '')

    {
      cfgText = if cfg.rsaCertFile == null then ""
        else ''
        ssl_enable=YES
        rsa_cert_file=${cfg.rsaCertFile}
      '';

      nixosOption = {
        name = "rsaCertFile";
        value = mkOption {
          default = null;
          description = ''
            rsa certificate file.
          '';
        };
      };
    }
    ];

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

        description = ''
          See <option>userlistFile</option>.
        '';
      };

      userlistFile = mkOption {
        default = pkgs.writeText "userlist" (concatMapStrings (x: "${x}\n") cfg.userlist);
        description = ''
          Newline separated list of names to be allowed/denied if <option>userlistEnable</option>
          is <literal>true</literal>. Meaning see <option>userlistDeny</option>.

          The default is a file containing the users from <option>userlist</option>.

          If explicitely set to null userlist_file will not be set in vsftpd's config file.
        '';
      };

      anonymousUserHome = mkOption {
        default = "/home/ftp/";
	description = ''
	  Directory to consider the HOME of the anonymous user.
	'';
      };

    } // (listToAttrs (catAttrs "nixosOption" optionDescription)) ;

  };


  ###### implementation

  config = mkIf cfg.enable {

    assertions = [
      {
        assertion =
              (cfg.forceLocalLoginsSSL -> cfg.rsaCertFile != null)
          &&  (cfg.forceLocalDataSSL -> cfg.rsaCertFile != null);
        message = "vsftpd: If forceLocalLoginsSSL or forceLocalDataSSL is true then a rsaCertFile must be provided!";
      }
    ];

    users.extraUsers =
      [ { name = "vsftpd";
          uid = config.ids.uids.vsftpd;
          description = "VSFTPD user";
          home = "/homeless-shelter";
        }
      ] ++ pkgs.lib.optional cfg.anonymousUser
        { name = "ftp";
          uid = config.ids.uids.ftp;
          group = "ftp";
          description = "Anonymous FTP user";
          home = cfg.anonymousUserHome;
        };

    users.extraGroups = singleton
      { name = "ftp";
        gid = config.ids.gids.ftp;
      };

    # If you really have to access root via FTP use mkOverride or userlistDeny
    # = false and whitelist root
    services.vsftpd.userlist = if cfg.userlistDeny then ["root"] else [];

    environment.etc."vsftpd.conf".text =
      concatMapStrings (x: "${x.cfgText}\n") optionDescription
      + ''
      ${if cfg.userlistFile == null then ""
        else "userlist_file=${cfg.userlistFile}"}
      background=NO
      listen=YES
      nopriv_user=vsftpd
      secure_chroot_dir=/var/empty
    '';

    jobs.vsftpd =
      { description = "vsftpd server";

        startOn = "started network-interfaces";
        stopOn = "stopping network-interfaces";

        preStart =
          ''
            ${if cfg.anonymousUser then ''
              mkdir -p -m 555 ${cfg.anonymousUserHome}
              chown -R ftp:ftp ${cfg.anonymousUserHome}
            '' else ""}
          '';

        exec = "${vsftpd}/sbin/vsftpd /etc/vsftpd.conf";
      };

  };

}
