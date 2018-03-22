{ lib, pkgs, ... }:

with lib;

{
  imports = [
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

    (mkRenamedOptionModule [ "services" "cadvisor" "host" ] [ "services" "cadvisor" "listenAddress" ])
    (mkChangedOptionModule [ "services" "printing" "gutenprint" ] [ "services" "printing" "drivers" ]
      (config:
        let enabled = getAttrFromPath [ "services" "printing" "gutenprint" ] config;
        in if enabled then [ pkgs.gutenprint ] else [ ]))
    (mkRenamedOptionModule [ "services" "elasticsearch" "host" ] [ "services" "elasticsearch" "listenAddress" ])
    (mkRenamedOptionModule [ "services" "graphite" "api" "host" ] [ "services" "graphite" "api" "listenAddress" ])
    (mkRenamedOptionModule [ "services" "graphite" "web" "host" ] [ "services" "graphite" "web" "listenAddress" ])
    (mkRenamedOptionModule [ "services" "i2pd" "extIp" ] [ "services" "i2pd" "address" ])
    (mkRenamedOptionModule [ "services" "kibana" "host" ] [ "services" "kibana" "listenAddress" ])
    (mkRenamedOptionModule [ "services" "logstash" "address" ] [ "services" "logstash" "listenAddress" ])
    (mkRenamedOptionModule [ "services" "mpd" "network" "host" ] [ "services" "mpd" "network" "listenAddress" ])
    (mkRenamedOptionModule [ "services" "neo4j" "host" ] [ "services" "neo4j" "listenAddress" ])
    (mkRenamedOptionModule [ "services" "shout" "host" ] [ "services" "shout" "listenAddress" ])
    (mkRenamedOptionModule [ "services" "sslh" "host" ] [ "services" "sslh" "listenAddress" ])
    (mkRenamedOptionModule [ "services" "statsd" "host" ] [ "services" "statsd" "listenAddress" ])
    (mkRenamedOptionModule [ "services" "subsonic" "host" ] [ "services" "subsonic" "listenAddress" ])
    (mkRenamedOptionModule [ "services" "tor" "relay" "portSpec" ] [ "services" "tor" "relay" "port" ])
    (mkRenamedOptionModule [ "jobs" ] [ "systemd" "services" ])

    (mkRenamedOptionModule [ "services" "gitlab" "stateDir" ] [ "services" "gitlab" "statePath" ])
    (mkRemovedOptionModule [ "services" "gitlab" "satelliteDir" ] "")

    (mkRenamedOptionModule [ "services" "clamav" "updater" "config" ] [ "services" "clamav" "updater" "extraConfig" ])

    (mkRemovedOptionModule [ "security" "setuidOwners" ] "Use security.wrappers instead")
    (mkRemovedOptionModule [ "security" "setuidPrograms" ] "Use security.wrappers instead")

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
    (mkRenamedOptionModule [ "config" "fonts" "fontconfig" "ultimate" "allowBitmaps" ] [ "config" "fonts" "fontconfig" "allowBitmaps" ])
    (mkRenamedOptionModule [ "config" "fonts" "fontconfig" "ultimate" "allowType1" ] [ "config" "fonts" "fontconfig" "allowType1" ])
    (mkRenamedOptionModule [ "config" "fonts" "fontconfig" "ultimate" "useEmbeddedBitmaps" ] [ "config" "fonts" "fontconfig" "useEmbeddedBitmaps" ])
    (mkRenamedOptionModule [ "config" "fonts" "fontconfig" "ultimate" "forceAutohint" ] [ "config" "fonts" "fontconfig" "forceAutohint" ])
    (mkRenamedOptionModule [ "config" "fonts" "fontconfig" "ultimate" "renderMonoTTFAsBitmap" ] [ "config" "fonts" "fontconfig" "renderMonoTTFAsBitmap" ])

    # Profile splitting
    (mkRenamedOptionModule [ "virtualization" "growPartition" ] [ "boot" "growPartition" ])

    # misc/version.nix
    (mkRenamedOptionModule [ "config" "system" "nixosVersion" ] [ "config" "system" "nixos" "version" ])
    (mkRenamedOptionModule [ "config" "system" "nixosRelease" ] [ "config" "system" "nixos" "release" ])
    (mkRenamedOptionModule [ "config" "system" "nixosVersionSuffix" ] [ "config" "system" "nixos" "versionSuffix" ])
    (mkRenamedOptionModule [ "config" "system" "nixosRevision" ] [ "config" "system" "nixos" "revision" ])
    (mkRenamedOptionModule [ "config" "system" "nixosCodeName" ] [ "config" "system" "nixos" "codeName" ])
    (mkRenamedOptionModule [ "config" "system" "nixosLabel" ] [ "config" "system" "nixos" "label" ])

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
    (mkRemovedOptionModule [ "fonts" "fontconfig" "forceAutohint" ] "")
    (mkRemovedOptionModule [ "fonts" "fontconfig" "renderMonoTTFAsBitmap" ] "")
    (mkRemovedOptionModule [ "virtualisation" "xen" "qemu" ] "You don't need this option anymore, it will work without it.")

    # ZSH
    (mkRenamedOptionModule [ "programs" "zsh" "enableSyntaxHighlighting" ] [ "programs" "zsh" "syntaxHighlighting" "enable" ])
    (mkRenamedOptionModule [ "programs" "zsh" "syntax-highlighting" "enable" ] [ "programs" "zsh" "syntaxHighlighting" "enable" ])
    (mkRenamedOptionModule [ "programs" "zsh" "syntax-highlighting" "highlighters" ] [ "programs" "zsh" "syntaxHighlighting" "highlighters" ])
    (mkRenamedOptionModule [ "programs" "zsh" "syntax-highlighting" "patterns" ] [ "programs" "zsh" "syntaxHighlighting" "patterns" ])
    (mkRenamedOptionModule [ "programs" "zsh" "oh-my-zsh" "enable" ] [ "programs" "zsh" "ohMyZsh" "enable" ])
    (mkRenamedOptionModule [ "programs" "zsh" "oh-my-zsh" "theme" ] [ "programs" "zsh" "ohMyZsh" "theme" ])
    (mkRenamedOptionModule [ "programs" "zsh" "oh-my-zsh" "custom" ] [ "programs" "zsh" "ohMyZsh" "custom" ])
    (mkRenamedOptionModule [ "programs" "zsh" "oh-my-zsh" "plugins" ] [ "programs" "zsh" "ohMyZsh" "plugins" ])

    # Xen
    (mkRenamedOptionModule [ "virtualisation" "xen" "qemu-package" ] [ "virtualisation" "xen" "package-qemu" ])
  ];
}
