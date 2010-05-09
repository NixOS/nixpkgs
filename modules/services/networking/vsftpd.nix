{ config, pkgs, ... }:

with pkgs.lib;

let 

  cfg = config.services.vsftpd;
  
  inherit (pkgs) vsftpd;

  yesNoOption = p : name :
    "${name}=${if p then "YES" else "NO"}";

in

{

  ###### interface

  options = {
  
    services.vsftpd = {
    
      enable = mkOption {
        default = false;
        description = "Whether to enable the vsftpd FTP server.";
      };

      anonymousUser = mkOption {
        default = false;
        description = "Whether to enable the anonymous FTP user.";
      };

      anonymousUserHome = mkOption {
        default = "/home/ftp";
        description = "Path to anonymous user data.";
      };

      localUsers = mkOption {
        default = false;
        description = "Whether to enable FTP for local users.";
      };

      writeEnable = mkOption {
        default = false;
        description = "Whether any write activity is permitted to users.";
      };

      anonymousUploadEnable = mkOption {
        default = false;
        description = "Whether any uploads are permitted to anonymous users.";
      };

      anonymousMkdirEnable = mkOption {
        default = false;
        description = "Whether mkdir is permitted to anonymous users.";
      };

      chrootlocalUser = mkOption {
        default = false;
        description = "Whether local users are confined to their home directory.";
      };

      userlistEnable = mkOption {
        default = false;
        description = "Whether users are included.";
      };

      userlistDeny = mkOption {
        default = false;
        description = "Whether users are excluded.";
      };

    };
    
  };
  

  ###### implementation

  config = mkIf cfg.enable {

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

    jobs.vsftpd =
      { description = "vsftpd server";

        startOn = "started network-interfaces";
        stopOn = "stopping network-interfaces";

        preStart =
          ''
            # !!! Why isn't this generated in the normal way?
            cat > /etc/vsftpd.conf <<EOF
            ${yesNoOption cfg.anonymousUser "anonymous_enable"}
            ${yesNoOption cfg.localUsers "local_enable"}
            ${yesNoOption cfg.writeEnable "write_enable"}
            ${yesNoOption cfg.anonymousUploadEnable "anon_upload_enable"}
            ${yesNoOption cfg.anonymousMkdirEnable "anon_mkdir_write_enable"}
            ${yesNoOption cfg.chrootlocalUser "chroot_local_user"}
            ${yesNoOption cfg.userlistEnable "userlist_enable"}
            ${yesNoOption cfg.userlistDeny "userlist_deny"}
            background=NO
            listen=YES
            nopriv_user=vsftpd
            secure_chroot_dir=/var/ftp/empty
            EOF

            ${if cfg.anonymousUser then ''
              mkdir -p ${cfg.anonymousUserHome}
              chown -R ftp:ftp ${cfg.anonymousUserHome}
            '' else ""}
          '';

        exec = "${vsftpd}/sbin/vsftpd /etc/vsftpd.conf";
      };

  };
  
}
