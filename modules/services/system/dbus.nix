# D-Bus system-wide daemon.
{pkgs, config, ...}:

with pkgs.lib;

let

  cfg = config.services.dbus;

  inherit (pkgs) dbus;

  homeDir = "/var/run/dbus";

  configFile = pkgs.stdenv.mkDerivation {
    name = "dbus-conf";
    buildCommand = ''
      ensureDir $out
      ln -s ${dbus}/etc/dbus-1/system.conf $out/system.conf

      # Note: system.conf includes ./system.d (i.e. it has a relative,
      # not absolute path).
      ensureDir $out/system.d
      for i in ${toString cfg.packages}; do
        ln -s $i/etc/dbus-1/system.d/* $out/system.d/
      done
    ''; # */
  };

in

{

  ###### interface

  options = {
  
    services.dbus = {

      enable = mkOption {
        default = true;
        description = ''
          Whether to start the D-Bus message bus daemon, which is
          required by many other system services and applications.
        '';
        merge = pkgs.lib.mergeEnableOption;
      };

      packages = mkOption {
        default = [];
        description = ''
          Packages whose D-Bus configuration files should be included in
          the configuration of the D-Bus system-wide message bus.
          Specifically, every file in
          <filename><replaceable>pkg</replaceable>/etc/dbus-1/system.d</filename>
          is included.
        '';
      };

    };
    
  };


  ###### implementation

  config = mkIf cfg.enable {

    environment.systemPackages = [dbus.daemon dbus.tools];

    users.extraUsers = singleton
      { name = "messagebus";
        uid = config.ids.uids.messagebus;
        description = "D-Bus system message bus daemon user";
        home = homeDir;
      };

    jobs = singleton
      { name = "dbus";

        startOn = "startup";
        stopOn = "shutdown";

        preStart =
          ''
            mkdir -m 0755 -p ${homeDir}
            chown messagebus ${homeDir}

            mkdir -m 0755 -p /var/lib/dbus
            ${dbus.tools}/bin/dbus-uuidgen --ensure
 
            rm -f ${homeDir}/pid
            # !!! hack - dbus should be running once this job is
            # considered "running"; should be fixable once we have
            # Upstart 0.6.
            ${dbus}/bin/dbus-daemon --config-file=${configFile}/system.conf
          '';

        postStop =
          ''
            pid=$(cat ${homeDir}/pid)
            if test -n "$pid"; then
                kill -9 $pid
            fi
          '';
      };

  };
 
}
