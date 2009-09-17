{pkgs, config, ...}:

###### interface
let
  inherit (pkgs.lib) mkOption mkIf;

  options = {
    services = {
      vsftpd = {
        enable = mkOption {
          default = false;
          description = "
            Whether to enable the vsftpd FTP server.
          ";
        };
        
        anonymousUser = mkOption {
          default = false;
          description = "
            Whether to enable the anonymous FTP user.
          ";
        };
 
        anonymousUserHome = mkOption {
          default = "/home/ftp";
          description = "
            Path to anonymous user data.
          ";
        };
 
        localUsers = mkOption {
          default = false;
          description = "
            Whether to enable FTP for the local users.
          ";
        };

        writeEnable = mkOption {
          default = false;
          description = "
            Whether any write activity is permitted to users.
          ";
        };

        anonymousUploadEnable = mkOption {
          default = false;
          description = "
            Whether any uploads are permitted to anonymous users.
          ";
        };

        anonymousMkdirEnable = mkOption {
          default = false;
          description = "
            Whether mkdir is permitted to anonymous users.
          ";
        };

        chrootlocalUser = mkOption {
          default = false;
          description = "
            Whether u can like out of ur home dir.
          ";
        };
  
        userlistEnable  = mkOption {
          default = false;
          description = "
            Whether users are included.
          ";
        };
  
        userlistDeny  = mkOption {
          default = false;
          description = "
            Whether users are excluded.
          ";
        };
      };
    };
  };
in

###### implementation

let 

  inherit (config.services.vsftpd) anonymousUser anonymousUserHome localUsers writeEnable anonymousUploadEnable anonymousMkdirEnable
    chrootlocalUser userlistEnable userlistDeny;
  inherit (pkgs) vsftpd;

  yesNoOption = p : name :
    "${name}=${if p then "YES" else "NO"}";

in

mkIf config.services.vsftpd.enable {
  require = [
    options
  ];

  users = {
    extraUsers = [
        { name = "vsftpd";
          uid = config.ids.uids.vsftpd;
          description = "VSFTPD user";
          home = "/homeless-shelter";
        }
      ] ++ pkgs.lib.optional anonymousUser
        { name = "ftp";
          uid = config.ids.uids.ftp;
          group = "ftp";
          description = "Anonymous ftp user";
          home = anonymousUserHome;
        };

    extraGroups = [
      { name = "ftp";
        gid = config.ids.gids.ftp;
      }
    ];
      
  };

  services = {
    extraJobs = [{
      name = "vsftpd";

      job = ''
        description "vsftpd server"

        start on network-interfaces/started
        stop on network-interfaces/stop

        start script
        cat > /etc/vsftpd.conf <<EOF
        ${yesNoOption anonymousUser "anonymous_enable"}
        ${yesNoOption localUsers "local_enable"}
        ${yesNoOption writeEnable "write_enable"}
        ${yesNoOption anonymousUploadEnable "anon_upload_enable"}
        ${yesNoOption anonymousMkdirEnable "anon_mkdir_write_enable"}
        ${yesNoOption chrootlocalUser "chroot_local_user"}
        ${yesNoOption userlistEnable "userlist_enable"}
        ${yesNoOption userlistDeny "userlist_deny"}
        background=NO
        listen=YES
        nopriv_user=vsftpd
        secure_chroot_dir=/var/ftp/empty
        EOF

        mkdir -p ${anonymousUserHome} &&
        chown -R ftp:ftp ${anonymousUserHome}
        end script

        respawn ${vsftpd}/sbin/vsftpd /etc/vsftpd.conf
      '';
      
    }];
  };
}
