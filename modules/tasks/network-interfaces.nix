{pkgs, config, ...}:

let

  inherit (pkgs.lib) mkOption;


###### interface

  options = {

    networking.hostName = mkOption {
      default = "nixos";
      description = "
        The name of the machine.  Leave it empty if you want to obtain
        it from a DHCP server (if using DHCP).
      ";
    };

    networking.nativeIPv6 = mkOption {
      default = false;
      description = "
        Whether to use IPv6 even though gw6c is not used. For example, 
        for Postfix.
      ";
    };

    networking.defaultGateway = mkOption {
      default = "";
      example = "131.211.84.1";
      description = "
        The default gateway.  It can be left empty if it is auto-detected through DHCP.
      ";
    };

    networking.nameservers = mkOption {
      default = [];
      example = ["130.161.158.4" "130.161.33.17"];
      description = "
        The list of nameservers.  It can be left empty if it is auto-detected through DHCP.
      ";
    };

    networking.domain = mkOption {
      default = "";
      example = "home";
      description = "
        The domain.  It can be left empty if it is auto-detected through DHCP.
      ";
    };

    networking.localCommands = mkOption {
      default = "";
      example = "text=anything; echo You can put $text here.";
      description = "
        Shell commands to be executed at the end of the
        <literal>network-interfaces</literal> Upstart job.  Note that if
        you are using DHCP to obtain the network configuration,
        interfaces may not be fully configured yet.
      ";
    };

  };


###### implementation

  inherit (pkgs) nettools wirelesstools bash writeText;

  cfg = config.networking;

  # !!! use XML
  names = map (i: i.name) cfg.interfaces;
  ipAddresses = map (i: if i ? ipAddress then i.ipAddress else "dhcp") cfg.interfaces;
  subnetMasks = map (i: if i ? subnetMask then i.subnetMask else "default") cfg.interfaces;
  essids = map (i: if i ? essid then i.essid else "default") cfg.interfaces;
  wepKeys = map (i: if i ? wepKey then i.wepKey else "nokey") cfg.interfaces;
  modprobe = config.system.sbin.modprobe;

in 

{
  require = [options];

  services.extraJobs = [{
    name = "network-interfaces";

    job = ''
      start on udev
      stop on shutdown

      start script
          export PATH=${modprobe}/sbin:$PATH
          modprobe af_packet || true

          for i in $(cd /sys/class/net && ls -d *); do
              echo "Bringing up network device $i..."
              ${nettools}/sbin/ifconfig $i up || true
          done

          # Configure the manually specified interfaces.
          names=(${toString names})
          ipAddresses=(${toString ipAddresses})
          subnetMasks=(${toString subnetMasks})
          essids=(${toString essids})
          wepKeys=(${toString wepKeys})

          for ((n = 0; n < ''${#names[*]}; n++)); do
              name=''${names[$n]}
              ipAddress=''${ipAddresses[$n]}
              subnetMask=''${subnetMasks[$n]}
              essid=''${essids[$n]}
              wepKey=''${wepKeys[$n]}

              # Set wireless networking stuff.
              if test "$essid" != default; then
                  ${wirelesstools}/sbin/iwconfig "$name" essid "$essid" || true
              fi

              if test "$wepKey" != nokey; then
                  ${wirelesstools}/sbin/iwconfig "$name" key "$(cat "$wepKey")" || true
              fi

              # Set IP address / netmask.        
              if test "$ipAddress" != dhcp; then
                  echo "Configuring interface $name..."
                  extraFlags=
                  if test "$subnetMask" != default; then
                      extraFlags="$extraFlags netmask $subnetMask"
                  fi
                  ${nettools}/sbin/ifconfig "$name" "$ipAddress" $extraFlags || true
              fi

          done

          # Set the nameservers.
          if test -n "${toString cfg.nameservers}"; then
              rm -f /etc/resolv.conf
              if test -n "${cfg.domain}"; then
                  echo "domain ${cfg.domain}" >> /etc/resolv.conf
              fi
              for i in ${toString cfg.nameservers}; do
                  echo "nameserver $i" >> /etc/resolv.conf
              done
          fi

          # Set the default gateway.
          if test -n "${cfg.defaultGateway}"; then
              ${nettools}/sbin/route add default gw "${cfg.defaultGateway}" || true
          fi

          # Run any user-specified commands.
          ${bash}/bin/sh ${writeText "local-net-cmds" cfg.localCommands} || true

      end script

      # Hack: Upstart doesn't yet support what we want: a service that
      # doesn't have a running process associated with it.
      respawn sleep 100000

      stop script
          for i in $(cd /sys/class/net && ls -d *); do
              echo "Taking down network device $i..."
              ${nettools}/sbin/ifconfig $i down || true
          done
      end script
    '';
  }];
}
