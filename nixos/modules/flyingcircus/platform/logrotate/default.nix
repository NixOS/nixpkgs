{ config, lib, pkgs, ... }: with lib;


let

  cfg = config;

  localConfig = if pathExists /etc/local/logrotate
    then "${/etc/local/logrotate}"
    else null;

  globalOptions = ''
      # Global default options for the Flying Circus platform.
      daily
      rotate 14
      create
      dateext
      delaycompress
      compress
      notifempty
      nomail
      noolddir
      missingok
      sharedscripts
  '';


in

{

  config = {

    services.logrotate.enable = true;
    services.logrotate.config = mkOrder 50 globalOptions;

    environment.etc = {
      "local/logrotate/README.txt".text = ''
        logrotate is enabled on this machine.

        You can put your application-specific logrotate snippets here
        and they will be executed regularly within the context of the
        owning user.

        The files must be placed in each service user's directory.

        /etc/local/logrotate/s-myapp/myapp
        /etc/local/logrotate/s-otherapp/something
        /etc/local/logrotate/s-serviceuser/somethingelse

        We will also apply the following basic options by default:

        ${globalOptions}
       '';
      "logrotate.options".text = globalOptions;
    };

    # We create one directory for each service user. I decided not to remove
    # old directories as this may be manually placed data that I don't want
    # to accidentally delete.
    system.activationScripts.logrotate-user = let
      users = attrValues cfg.users.users;
      service_users = builtins.filter (user: user.group == "service") users;
    in stringAfter [ "users" ]
    ''
      # Enable service users to place logrotate snippets.
      install -d -o root -g root -m 0755 /etc/local/logrotate
      ${builtins.concatStringsSep "\n"
        (map
          (user: ''
            install -d -m 0755 -o ${user.name} -g service /etc/local/logrotate/${user.name}
            ${pkgs.systemd}/bin/systemd-run --setenv=XDG_RUNTIME_DIR="/run/user/${toString user.uid}" --uid ${user.name}  ${pkgs.systemd}/bin/systemctl --user daemon-reload
            '')
          service_users)}
      install -d -o root -g service -m 02775 /var/spool/logrotate
    '';

    systemd.user.services.logrotate-user = mkIf (localConfig != null) {
      description   = "User Logrotate Service";
      wantedBy      = [ "default.target" ];
      startAt       = "*-*-* 02:05:00";

      path = [ pkgs.bash pkgs.logrotate ];

      serviceConfig.Restart = "no";
      serviceConfig.ExecStart = "${./user-logrotate.sh} ${localConfig}";
    };

  };


}
