{ pkgs, ... }:
{
  name = "sogo";
  meta = {
    maintainers = [ ];
  };

  nodes = {
    sogo =
      { config, pkgs, ... }:
      {
        services.nginx.enable = true;

        services.mysql = {
          enable = true;
          package = pkgs.mariadb;
          ensureDatabases = [ "sogo" ];
          ensureUsers = [
            {
              name = "sogo";
              ensurePermissions = {
                "sogo.*" = "ALL PRIVILEGES";
              };
            }
          ];
        };

        services.sogo = {
          enable = true;
          timezone = "Europe/Berlin";
          extraConfig = ''
            WOWorkersCount = 1;

            SOGoUserSources = (
              {
                type = sql;
                userPasswordAlgorithm = md5;
                viewURL = "mysql://sogo@%2Frun%2Fmysqld%2Fmysqld.sock/sogo/sogo_users";
                canAuthenticate = YES;
                id = users;
              }
            );

            SOGoProfileURL = "mysql://sogo@%2Frun%2Fmysqld%2Fmysqld.sock/sogo/sogo_user_profile";
            OCSFolderInfoURL = "mysql://sogo@%2Frun%2Fmysqld%2Fmysqld.sock/sogo/sogo_folder_info";
            OCSSessionsFolderURL = "mysql://sogo@%2Frun%2Fmysqld%2Fmysqld.sock/sogo/sogo_sessions_folder";
            OCSEMailAlarmsFolderURL = "mysql://sogo@%2Frun%2Fmysqld%2Fmysqld.sock/sogo/sogo_alarms_folder";
            OCSStoreURL = "mysql://sogo@%2Frun%2Fmysqld%2Fmysqld.sock/sogo/sogo_store";
            OCSAclURL = "mysql://sogo@%2Frun%2Fmysqld%2Fmysqld.sock/sogo/sogo_acl";
            OCSCacheFolderURL = "mysql://sogo@%2Frun%2Fmysqld%2Fmysqld.sock/sogo/sogo_cache_folder";
          '';
        };
      };
  };

  testScript = ''
    start_all()
    sogo.wait_for_unit("multi-user.target")
    sogo.wait_for_open_port(20000)
    sogo.wait_for_open_port(80)
    sogo.succeed("curl -sSfL http://sogo/SOGo")
  '';
}
