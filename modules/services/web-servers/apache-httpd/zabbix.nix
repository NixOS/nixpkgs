{ config, pkgs, serverInfo, ... }:

let

  # The Zabbix PHP frontend needs to be able to write its
  # configuration settings (the connection info to the database) to
  # the "conf" subdirectory.  So symlink $out/conf to some directory
  # outside of the Nix store where we want to keep this stateful info.
  # Note that different instances of the frontend will therefore end
  # up with their own copies of the PHP sources.  !!! Alternatively,
  # we could generate zabbix.conf.php declaratively.
  zabbixPHP = pkgs.runCommand "${pkgs.zabbix.server.name}-php" {}
    ''
      cp -rs ${pkgs.zabbix.server}/share/zabbix/php $out
      chmod -R u+w $out
      #rm -rf $out/conf
      ln -s ${config.stateDir}/zabbix.conf.php $out/conf/zabbix.conf.php
    '';

in

{

  extraModules =
    [ { name = "php5"; path = "${pkgs.php}/modules/libphp5.so"; } ];

  phpOptions =
    ''
      post_max_size = 32M
      max_execution_time = 300
      mbstring.func_overload = 2
    '';
  
  extraConfig = ''
    Alias ${config.urlPrefix}/ ${zabbixPHP}/
    
    <Directory ${zabbixPHP}>
      DirectoryIndex index.php
      Order deny,allow
      Allow from *
    </Directory>
  '';

  startupScript = pkgs.writeScript "zabbix-startup-hook" ''
    mkdir -p ${config.stateDir}
    chown -R ${serverInfo.serverConfig.user} ${config.stateDir}
  '';

  # The frontend needs "ps" to find out whether zabbix_server is running.
  extraServerPath = ["${pkgs.procps}/bin"];

  options = {

    urlPrefix = pkgs.lib.mkOption {
      default = "/zabbix";
      description = "
        The URL prefix under which the Zabbix service appears.
        Use the empty string to have it appear in the server root.
      ";
    };

    stateDir = pkgs.lib.mkOption {
      default = "/var/lib/zabbix/frontend";
      description = "
        Directory where the dynamically generated configuration data
        of the PHP frontend will be stored.
      ";
    };

  };

}
