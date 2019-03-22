{ lib, pkgs, ... }:

with lib;

{
  imports = [
    # !!! These were renamed the other way, but got reverted later.
    # !!! Drop these before 18.09 is released.
    (mkRenamedOptionModule [ "system" "nixos" "stateVersion" ] [ "system" "stateVersion" ])
    (mkRenamedOptionModule [ "system" "nixos" "defaultChannel" ] [ "system" "defaultChannel" ])

    (mkRenamedOptionModule [ "environment" "x11Packages" ] [ "environment" "systemPackages" ])
    (mkRenamedOptionModule [ "environment" "enableBashCompletion" ] [ "programs" "bash" "enableCompletion" ])
    (mkRenamedOptionModule [ "environment" "nix" ] [ "nix" "package" ])
    (mkRenamedOptionModule [ "fonts" "enableFontConfig" ] [ "fonts" "fontconfig" "enable" ])
    (mkRenamedOptionModule [ "fonts" "extraFonts" ] [ "fonts" "fonts" ])

    (mkRenamedOptionModule [ "networking" "enableWLAN" ] [ "networking" "wireless" "enable" ])
    (mkRenamedOptionModule [ "networking" "enableRT73Firmware" ] [ "hardware" "enableRedistributableFirmware" ])
    (mkRenamedOptionModule [ "networking" "enableIntel3945ABGFirmware" ] [ "hardware" "enableRedistributableFirmware" ])
    (mkRenamedOptionModule [ "networking" "enableIntel2100BGFirmware" ] [ "hardware" "enableRedistributableFirmware" ])
    (mkRenamedOptionModule [ "networking" "enableRalinkFirmware" ] [ "hardware" "enableRedistributableFirmware" ])
    (mkRenamedOptionModule [ "networking" "enableRTL8192cFirmware" ] [ "hardware" "enableRedistributableFirmware" ])
    (mkRenamedOptionModule [ "networking" "networkmanager" "useDnsmasq" ] [ "networking" "networkmanager" "dns" ])

    (mkRenamedOptionModule [ "services" "cadvisor" "host" ] [ "services" "cadvisor" "listenAddress" ])
    (mkChangedOptionModule [ "services" "printing" "gutenprint" ] [ "services" "printing" "drivers" ]
      (config:
        let enabled = getAttrFromPath [ "services" "printing" "gutenprint" ] config;
        in if enabled then [ pkgs.gutenprint ] else [ ]))
    (mkChangedOptionModule [ "services" "ddclient" "domain" ] [ "services" "ddclient" "domains" ]
      (config:
        let value = getAttrFromPath [ "services" "ddclient" "domain" ] config;
        in if value != "" then [ value ] else []))
    (mkRemovedOptionModule [ "services" "ddclient" "homeDir" ] "")
    (mkRenamedOptionModule [ "services" "elasticsearch" "host" ] [ "services" "elasticsearch" "listenAddress" ])
    (mkRenamedOptionModule [ "services" "graphite" "api" "host" ] [ "services" "graphite" "api" "listenAddress" ])
    (mkRenamedOptionModule [ "services" "graphite" "web" "host" ] [ "services" "graphite" "web" "listenAddress" ])
    (mkRenamedOptionModule [ "services" "i2pd" "extIp" ] [ "services" "i2pd" "address" ])
    (mkRenamedOptionModule [ "services" "kibana" "host" ] [ "services" "kibana" "listenAddress" ])
    (mkRenamedOptionModule [ "services" "kubernetes" "apiserver" "admissionControl" ] [ "services" "kubernetes" "apiserver" "enableAdmissionPlugins" ])
    (mkRenamedOptionModule [ "services" "kubernetes" "apiserver" "address" ] ["services" "kubernetes" "apiserver" "bindAddress"])
    (mkRenamedOptionModule [ "services" "kubernetes" "apiserver" "port" ] ["services" "kubernetes" "apiserver" "insecurePort"])
    (mkRemovedOptionModule [ "services" "kubernetes" "apiserver" "publicAddress" ] "")
    (mkRenamedOptionModule [ "services" "kubernetes" "addons" "dashboard" "enableRBAC" ] [ "services" "kubernetes" "addons" "dashboard" "rbac" "enable" ])
    (mkRenamedOptionModule [ "services" "kubernetes" "controllerManager" "address" ] ["services" "kubernetes" "controllerManager" "bindAddress"])
    (mkRenamedOptionModule [ "services" "kubernetes" "controllerManager" "port" ] ["services" "kubernetes" "controllerManager" "insecurePort"])
    (mkRenamedOptionModule [ "services" "kubernetes" "etcd" "servers" ] [ "services" "kubernetes" "apiserver" "etcd" "servers" ])
    (mkRenamedOptionModule [ "services" "kubernetes" "etcd" "keyFile" ] [ "services" "kubernetes" "apiserver" "etcd" "keyFile" ])
    (mkRenamedOptionModule [ "services" "kubernetes" "etcd" "certFile" ] [ "services" "kubernetes" "apiserver" "etcd" "certFile" ])
    (mkRenamedOptionModule [ "services" "kubernetes" "etcd" "caFile" ] [ "services" "kubernetes" "apiserver" "etcd" "caFile" ])
    (mkRemovedOptionModule [ "services" "kubernetes" "kubelet" "applyManifests" ] "")
    (mkRemovedOptionModule [ "services" "kubernetes" "kubelet" "cadvisorPort" ] "")
    (mkRenamedOptionModule [ "services" "kubernetes" "proxy" "address" ] ["services" "kubernetes" "proxy" "bindAddress"])
    (mkRemovedOptionModule [ "services" "kubernetes" "verbose" ] "")
    (mkRenamedOptionModule [ "services" "logstash" "address" ] [ "services" "logstash" "listenAddress" ])
    (mkRenamedOptionModule [ "services" "mpd" "network" "host" ] [ "services" "mpd" "network" "listenAddress" ])
    (mkRenamedOptionModule [ "services" "neo4j" "host" ] [ "services" "neo4j" "defaultListenAddress" ])
    (mkRenamedOptionModule [ "services" "neo4j" "listenAddress" ] [ "services" "neo4j" "defaultListenAddress" ])
    (mkRenamedOptionModule [ "services" "neo4j" "enableBolt" ] [ "services" "neo4j" "bolt" "enable" ])
    (mkRenamedOptionModule [ "services" "neo4j" "enableHttps" ] [ "services" "neo4j" "https" "enable" ])
    (mkRenamedOptionModule [ "services" "neo4j" "certDir" ] [ "services" "neo4j" "directories" "certificates" ])
    (mkRenamedOptionModule [ "services" "neo4j" "dataDir" ] [ "services" "neo4j" "directories" "home" ])
    (mkRemovedOptionModule [ "services" "neo4j" "port" ] "Use services.neo4j.http.listenAddress instead.")
    (mkRemovedOptionModule [ "services" "neo4j" "boltPort" ] "Use services.neo4j.bolt.listenAddress instead.")
    (mkRemovedOptionModule [ "services" "neo4j" "httpsPort" ] "Use services.neo4j.https.listenAddress instead.")
    (mkRenamedOptionModule [ "services" "shout" "host" ] [ "services" "shout" "listenAddress" ])
    (mkRenamedOptionModule [ "services" "sslh" "host" ] [ "services" "sslh" "listenAddress" ])
    (mkRenamedOptionModule [ "services" "statsd" "host" ] [ "services" "statsd" "listenAddress" ])
    (mkRenamedOptionModule [ "services" "subsonic" "host" ] [ "services" "subsonic" "listenAddress" ])
    (mkRenamedOptionModule [ "services" "tor" "relay" "portSpec" ] [ "services" "tor" "relay" "port" ])
    (mkRenamedOptionModule [ "services" "vmwareGuest" ] [ "virtualisation" "vmware" "guest" ])
    (mkRenamedOptionModule [ "jobs" ] [ "systemd" "services" ])

    (mkRenamedOptionModule [ "services" "gitlab" "stateDir" ] [ "services" "gitlab" "statePath" ])
    (mkRemovedOptionModule [ "services" "gitlab" "satelliteDir" ] "")

    (mkRenamedOptionModule [ "services" "clamav" "updater" "config" ] [ "services" "clamav" "updater" "extraConfig" ])

    (mkRemovedOptionModule [ "security" "setuidOwners" ] "Use security.wrappers instead")
    (mkRemovedOptionModule [ "security" "setuidPrograms" ] "Use security.wrappers instead")

    # PAM
    (mkRenamedOptionModule [ "security" "pam" "enableU2F" ] [ "security" "pam" "u2f" "enable" ])

    (mkRemovedOptionModule [ "services" "rmilter" "bindInetSockets" ] "Use services.rmilter.bindSocket.* instead")
    (mkRemovedOptionModule [ "services" "rmilter" "bindUnixSockets" ] "Use services.rmilter.bindSocket.* instead")

    # Xsession script
    (mkRenamedOptionModule [ "services" "xserver" "displayManager" "job" "logsXsession" ] [ "services" "xserver" "displayManager" "job" "logToFile" ])
    (mkRenamedOptionModule [ "services" "xserver" "displayManager" "logToJournal" ] [ "services" "xserver" "displayManager" "job" "logToJournal" ])

    # Old Grub-related options.
    (mkRenamedOptionModule [ "boot" "initrd" "extraKernelModules" ] [ "boot" "initrd" "kernelModules" ])
    (mkRenamedOptionModule [ "boot" "extraKernelParams" ] [ "boot" "kernelParams" ])
    (mkRenamedOptionModule [ "boot" "loader" "grub" "timeout" ] [ "boot" "loader" "timeout" ])
    (mkRenamedOptionModule [ "boot" "loader" "gummiboot" "timeout" ] [ "boot" "loader" "timeout" ])

    # smartd
    (mkRenamedOptionModule [ "services" "smartd" "deviceOpts" ] [ "services" "smartd" "defaults" "monitored" ])

    # OpenSSH
    (mkRenamedOptionModule [ "services" "sshd" "ports" ] [ "services" "openssh" "ports" ])
    (mkAliasOptionModule [ "services" "sshd" "enable" ] [ "services" "openssh" "enable" ])
    (mkRenamedOptionModule [ "services" "sshd" "allowSFTP" ] [ "services" "openssh" "allowSFTP" ])
    (mkRenamedOptionModule [ "services" "sshd" "forwardX11" ] [ "services" "openssh" "forwardX11" ])
    (mkRenamedOptionModule [ "services" "sshd" "gatewayPorts" ] [ "services" "openssh" "gatewayPorts" ])
    (mkRenamedOptionModule [ "services" "sshd" "permitRootLogin" ] [ "services" "openssh" "permitRootLogin" ])
    (mkRenamedOptionModule [ "services" "xserver" "startSSHAgent" ] [ "services" "xserver" "startOpenSSHAgent" ])
    (mkRenamedOptionModule [ "services" "xserver" "startOpenSSHAgent" ] [ "programs" "ssh" "startAgent" ])
    (mkAliasOptionModule [ "services" "openssh" "knownHosts" ] [ "programs" "ssh" "knownHosts" ])

    # VirtualBox
    (mkRenamedOptionModule [ "services" "virtualbox" "enable" ] [ "virtualisation" "virtualbox" "guest" "enable" ])
    (mkRenamedOptionModule [ "services" "virtualboxGuest" "enable" ] [ "virtualisation" "virtualbox" "guest" "enable" ])
    (mkRenamedOptionModule [ "programs" "virtualbox" "enable" ] [ "virtualisation" "virtualbox" "host" "enable" ])
    (mkRenamedOptionModule [ "programs" "virtualbox" "addNetworkInterface" ] [ "virtualisation" "virtualbox" "host" "addNetworkInterface" ])
    (mkRenamedOptionModule [ "programs" "virtualbox" "enableHardening" ] [ "virtualisation" "virtualbox" "host" "enableHardening" ])
    (mkRenamedOptionModule [ "services" "virtualboxHost" "enable" ] [ "virtualisation" "virtualbox" "host" "enable" ])
    (mkRenamedOptionModule [ "services" "virtualboxHost" "addNetworkInterface" ] [ "virtualisation" "virtualbox" "host" "addNetworkInterface" ])
    (mkRenamedOptionModule [ "services" "virtualboxHost" "enableHardening" ] [ "virtualisation" "virtualbox" "host" "enableHardening" ])

    # libvirtd
    (mkRemovedOptionModule [ "virtualisation" "libvirtd" "enableKVM" ]
      "Set the option `virtualisation.libvirtd.qemuPackage' instead.")

    # Tarsnap
    (mkRenamedOptionModule [ "services" "tarsnap" "config" ] [ "services" "tarsnap" "archives" ])

    # ibus
    (mkRenamedOptionModule [ "programs" "ibus" "plugins" ] [ "i18n" "inputMethod" "ibus" "engines" ])

    # proxy
    (mkRenamedOptionModule [ "nix" "proxy" ] [ "networking" "proxy" "default" ])

    # sandboxing
    (mkRenamedOptionModule [ "nix" "useChroot" ] [ "nix" "useSandbox" ])
    (mkRenamedOptionModule [ "nix" "chrootDirs" ] [ "nix" "sandboxPaths" ])

    # KDE
    (mkRenamedOptionModule [ "kde" "extraPackages" ] [ "environment" "systemPackages" ])
    (mkRenamedOptionModule [ "environment" "kdePackages" ] [ "environment" "systemPackages" ])

    # Multiple efi bootloaders now
    (mkRenamedOptionModule [ "boot" "loader" "efi" "efibootmgr" "enable" ] [ "boot" "loader" "efi" "canTouchEfiVariables" ])

    # NixOS environment changes
    # !!! this hardcodes bash, could we detect from config which shell is actually used?
    (mkRenamedOptionModule [ "environment" "promptInit" ] [ "programs" "bash" "promptInit" ])

    (mkRenamedOptionModule [ "services" "xserver" "driSupport" ] [ "hardware" "opengl" "driSupport" ])
    (mkRenamedOptionModule [ "services" "xserver" "driSupport32Bit" ] [ "hardware" "opengl" "driSupport32Bit" ])
    (mkRenamedOptionModule [ "services" "xserver" "s3tcSupport" ] [ "hardware" "opengl" "s3tcSupport" ])
    (mkRenamedOptionModule [ "hardware" "opengl" "videoDrivers" ] [ "services" "xserver" "videoDrivers" ])
    (mkRenamedOptionModule [ "services" "xserver" "vaapiDrivers" ] [ "hardware" "opengl" "extraPackages" ])

    (mkRenamedOptionModule [ "services" "mysql55" ] [ "services" "mysql" ])

    (mkAliasOptionModule [ "environment" "checkConfigurationOptions" ] [ "_module" "check" ])

    # opendkim
    (mkRenamedOptionModule [ "services" "opendkim" "keyFile" ] [ "services" "opendkim" "keyPath" ])

    # XBMC
    (mkRenamedOptionModule [ "services" "xserver" "windowManager" "xbmc" ] [ "services" "xserver" "desktopManager" "kodi" ])
    (mkRenamedOptionModule [ "services" "xserver" "desktopManager" "xbmc" ] [ "services" "xserver" "desktopManager" "kodi" ])

    (mkRenamedOptionModule [ "services" "hostapd" "extraCfg" ] [ "services" "hostapd" "extraConfig" ])

    # Enlightenment
    (mkRenamedOptionModule [ "services" "xserver" "desktopManager" "e19" "enable" ] [ "services" "xserver" "desktopManager" "enlightenment" "enable" ])

    # Iodine
    (mkRenamedOptionModule [ "services" "iodined" "enable" ] [ "services" "iodine" "server" "enable" ])
    (mkRenamedOptionModule [ "services" "iodined" "domain" ] [ "services" "iodine" "server" "domain" ])
    (mkRenamedOptionModule [ "services" "iodined" "ip" ] [ "services" "iodine" "server" "ip" ])
    (mkRenamedOptionModule [ "services" "iodined" "extraConfig" ] [ "services" "iodine" "server" "extraConfig" ])
    (mkRemovedOptionModule [ "services" "iodined" "client" ] "")

    # Unity3D
    (mkRenamedOptionModule [ "programs" "unity3d" "enable" ] [ "security" "chromiumSuidSandbox" "enable" ])

    # murmur
    (mkRenamedOptionModule [ "services" "murmur" "welcome" ] [ "services" "murmur" "welcometext" ])

    # parsoid
    (mkRemovedOptionModule [ "services" "parsoid" "interwikis" ] [ "services" "parsoid" "wikis" ])

    # plexpy / tautulli
    (mkRenamedOptionModule [ "services" "plexpy" ] [ "services" "tautulli" ])

    # piwik was renamed to matomo
    (mkRenamedOptionModule [ "services" "piwik" "enable" ] [ "services" "matomo" "enable" ])
    (mkRenamedOptionModule [ "services" "piwik" "webServerUser" ] [ "services" "matomo" "webServerUser" ])
    (mkRenamedOptionModule [ "services" "piwik" "phpfpmProcessManagerConfig" ] [ "services" "matomo" "phpfpmProcessManagerConfig" ])
    (mkRenamedOptionModule [ "services" "piwik" "nginx" ] [ "services" "matomo" "nginx" ])

    # tarsnap
    (mkRemovedOptionModule [ "services" "tarsnap" "cachedir" ] "Use services.tarsnap.archives.<name>.cachedir")

    # alsa
    (mkRenamedOptionModule [ "sound" "enableMediaKeys" ] [ "sound" "mediaKeys" "enable" ])

    # postgrey
    (mkMergedOptionModule [ [ "services" "postgrey" "inetAddr" ] [ "services" "postgrey" "inetPort" ] ] [ "services" "postgrey" "socket" ] (config: let
        value = p: getAttrFromPath p config;
        inetAddr = [ "services" "postgrey" "inetAddr" ];
        inetPort = [ "services" "postgrey" "inetPort" ];
      in
        if value inetAddr == null
        then { path = "/var/run/postgrey.sock"; }
        else { addr = value inetAddr; port = value inetPort; }
    ))

    # dhcpd
    (mkRenamedOptionModule [ "services" "dhcpd" ] [ "services" "dhcpd4" ])

    # locate
    (mkRenamedOptionModule [ "services" "locate" "period" ] [ "services" "locate" "interval" ])
    (mkRemovedOptionModule [ "services" "locate" "includeStore" ] "Use services.locate.prunePaths" )

    # nfs
    (mkRenamedOptionModule [ "services" "nfs" "lockdPort" ] [ "services" "nfs" "server" "lockdPort" ])
    (mkRenamedOptionModule [ "services" "nfs" "statdPort" ] [ "services" "nfs" "server" "statdPort" ])

    # KDE Plasma 5
    (mkRenamedOptionModule [ "services" "xserver" "desktopManager" "kde5" ] [ "services" "xserver" "desktopManager" "plasma5" ])

    # Fontconfig
    (mkRenamedOptionModule [ "fonts" "fontconfig" "ultimate" "allowBitmaps" ] [ "fonts" "fontconfig" "allowBitmaps" ])
    (mkRenamedOptionModule [ "fonts" "fontconfig" "ultimate" "allowType1" ] [ "fonts" "fontconfig" "allowType1" ])
    (mkRenamedOptionModule [ "fonts" "fontconfig" "ultimate" "useEmbeddedBitmaps" ] [ "fonts" "fontconfig" "useEmbeddedBitmaps" ])
    (mkRenamedOptionModule [ "fonts" "fontconfig" "ultimate" "forceAutohint" ] [ "fonts" "fontconfig" "forceAutohint" ])
    (mkRenamedOptionModule [ "fonts" "fontconfig" "ultimate" "renderMonoTTFAsBitmap" ] [ "fonts" "fontconfig" "renderMonoTTFAsBitmap" ])

    # postgresqlBackup
    (mkRemovedOptionModule [ "services" "postgresqlBackup" "period" ] ''
       A systemd timer is now used instead of cron.
       The starting time can be configured via <literal>services.postgresqlBackup.startAt</literal>.
    '')

    # Profile splitting
    (mkRenamedOptionModule [ "virtualisation" "growPartition" ] [ "boot" "growPartition" ])

    # misc/version.nix
    (mkRenamedOptionModule [ "system" "nixosVersion" ] [ "system" "nixos" "version" ])
    (mkRenamedOptionModule [ "system" "nixosVersionSuffix" ] [ "system" "nixos" "versionSuffix" ])
    (mkRenamedOptionModule [ "system" "nixosRevision" ] [ "system" "nixos" "revision" ])
    (mkRenamedOptionModule [ "system" "nixosLabel" ] [ "system" "nixos" "label" ])

    # Users
    (mkAliasOptionModule [ "users" "extraUsers" ] [ "users" "users" ])
    (mkAliasOptionModule [ "users" "extraGroups" ] [ "users" "groups" ])

    # Options that are obsolete and have no replacement.
    (mkRemovedOptionModule [ "boot" "initrd" "luks" "enable" ] "")
    (mkRemovedOptionModule [ "programs" "bash" "enable" ] "")
    (mkRemovedOptionModule [ "services" "samba" "defaultShare" ] "")
    (mkRemovedOptionModule [ "services" "syslog-ng" "serviceName" ] "")
    (mkRemovedOptionModule [ "services" "syslog-ng" "listenToJournal" ] "")
    (mkRemovedOptionModule [ "ec2" "metadata" ] "")
    (mkRemovedOptionModule [ "services" "openvpn" "enable" ] "")
    (mkRemovedOptionModule [ "services" "printing" "cupsFilesConf" ] "")
    (mkRemovedOptionModule [ "services" "printing" "cupsdConf" ] "")
    (mkRemovedOptionModule [ "services" "tor" "relay" "isBridge" ] "Use services.tor.relay.role instead.")
    (mkRemovedOptionModule [ "services" "tor" "relay" "isExit" ] "Use services.tor.relay.role instead.")
    (mkRemovedOptionModule [ "services" "xserver" "startGnuPGAgent" ]
      "See the 16.09 release notes for more information.")
    (mkRemovedOptionModule [ "services" "phpfpm" "phpIni" ] "")
    (mkRemovedOptionModule [ "services" "dovecot2" "package" ] "")
    (mkRemovedOptionModule [ "services" "firefox" "syncserver" "user" ] "")
    (mkRemovedOptionModule [ "services" "firefox" "syncserver" "group" ] "")
    (mkRemovedOptionModule [ "fonts" "fontconfig" "hinting" "style" ] "")
    (mkRemovedOptionModule [ "services" "xserver" "displayManager" "sddm" "themes" ]
      "Set the option `services.xserver.displayManager.sddm.package' instead.")
    (mkRemovedOptionModule [ "services" "xserver" "desktopManager" "xfce" "screenLock" ] "")
    (mkRemovedOptionModule [ "fonts" "fontconfig" "forceAutohint" ] "")
    (mkRemovedOptionModule [ "fonts" "fontconfig" "renderMonoTTFAsBitmap" ] "")
    (mkRemovedOptionModule [ "virtualisation" "xen" "qemu" ] "You don't need this option anymore, it will work without it.")
    (mkRemovedOptionModule [ "services" "logstash" "enableWeb" ] "The web interface was removed from logstash")
    (mkRemovedOptionModule [ "boot" "zfs" "enableLegacyCrypto" ] "The corresponding package was removed from nixpkgs.")

    # ZSH
    (mkRenamedOptionModule [ "programs" "zsh" "enableSyntaxHighlighting" ] [ "programs" "zsh" "syntaxHighlighting" "enable" ])
    (mkRenamedOptionModule [ "programs" "zsh" "syntax-highlighting" "enable" ] [ "programs" "zsh" "syntaxHighlighting" "enable" ])
    (mkRenamedOptionModule [ "programs" "zsh" "syntax-highlighting" "highlighters" ] [ "programs" "zsh" "syntaxHighlighting" "highlighters" ])
    (mkRenamedOptionModule [ "programs" "zsh" "syntax-highlighting" "patterns" ] [ "programs" "zsh" "syntaxHighlighting" "patterns" ])
    (mkRenamedOptionModule [ "programs" "zsh" "oh-my-zsh" "enable" ] [ "programs" "zsh" "ohMyZsh" "enable" ])
    (mkRenamedOptionModule [ "programs" "zsh" "oh-my-zsh" "theme" ] [ "programs" "zsh" "ohMyZsh" "theme" ])
    (mkRenamedOptionModule [ "programs" "zsh" "oh-my-zsh" "custom" ] [ "programs" "zsh" "ohMyZsh" "custom" ])
    (mkRenamedOptionModule [ "programs" "zsh" "oh-my-zsh" "plugins" ] [ "programs" "zsh" "ohMyZsh" "plugins" ])

    (mkRenamedOptionModule [ "programs" "zsh" "enableAutosuggestions" ] [ "programs" "zsh" "autosuggestions" "enable" ])

    # Xen
    (mkRenamedOptionModule [ "virtualisation" "xen" "qemu-package" ] [ "virtualisation" "xen" "package-qemu" ])

    (mkRenamedOptionModule [ "programs" "info" "enable" ] [ "documentation" "info" "enable" ])
    (mkRenamedOptionModule [ "programs" "man"  "enable" ] [ "documentation" "man"  "enable" ])
    (mkRenamedOptionModule [ "services" "nixosManual" "enable" ] [ "documentation" "nixos" "enable" ])

    # ckb
    (mkRenamedOptionModule [ "hardware" "ckb" "enable" ] [ "hardware" "ckb-next" "enable" ])
    (mkRenamedOptionModule [ "hardware" "ckb" "package" ] [ "hardware" "ckb-next" "package" ])

  ] ++ (flip map [ "blackboxExporter" "collectdExporter" "fritzboxExporter"
                   "jsonExporter" "minioExporter" "nginxExporter" "nodeExporter"
                   "snmpExporter" "unifiExporter" "varnishExporter" ]
       (opt: mkRemovedOptionModule [ "services" "prometheus" "${opt}" ] ''
         The prometheus exporters are now configured using `services.prometheus.exporters'.
         See the 18.03 release notes for more information.
       '' ));
}
