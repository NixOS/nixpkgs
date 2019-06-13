{ config, lib, pkgs, ...} :

with lib;

let
  cfg = config.services.beegfs;

  # functions for the generations of config files

  configMgmtd = name: cfg: pkgs.writeText "mgmt-${name}.conf" ''
    storeMgmtdDirectory = ${cfg.mgmtd.storeDir}
    storeAllowFirstRunInit = false
    connAuthFile = ${cfg.connAuthFile}
    connPortShift = ${toString cfg.connPortShift}

    ${cfg.mgmtd.extraConfig}
  '';

  configAdmon = name: cfg: pkgs.writeText "admon-${name}.conf" ''
    sysMgmtdHost = ${cfg.mgmtdHost}
    connAuthFile = ${cfg.connAuthFile}
    connPortShift = ${toString cfg.connPortShift}

    ${cfg.admon.extraConfig}
  '';

  configMeta = name: cfg: pkgs.writeText "meta-${name}.conf" ''
    storeMetaDirectory = ${cfg.meta.storeDir}
    sysMgmtdHost = ${cfg.mgmtdHost}
    connAuthFile = ${cfg.connAuthFile}
    connPortShift = ${toString cfg.connPortShift}
    storeAllowFirstRunInit = false

    ${cfg.meta.extraConfig}
  '';

  configStorage = name: cfg: pkgs.writeText "storage-${name}.conf" ''
    storeStorageDirectory = ${cfg.storage.storeDir}
    sysMgmtdHost = ${cfg.mgmtdHost}
    connAuthFile = ${cfg.connAuthFile}
    connPortShift = ${toString cfg.connPortShift}
    storeAllowFirstRunInit = false

    ${cfg.storage.extraConfig}
  '';

  configHelperd = name: cfg: pkgs.writeText "helperd-${name}.conf" ''
    connAuthFile = ${cfg.connAuthFile}
    ${cfg.helperd.extraConfig}
  '';

  configClientFilename = name : "/etc/beegfs/client-${name}.conf";

  configClient = name: cfg: ''
    sysMgmtdHost = ${cfg.mgmtdHost}
    connAuthFile = ${cfg.connAuthFile}
    connPortShift = ${toString cfg.connPortShift}

    ${cfg.client.extraConfig}
  '';

  serviceList = [
    { service = "admon"; cfgFile = configAdmon; }
    { service = "meta"; cfgFile = configMeta; }
    { service = "mgmtd"; cfgFile = configMgmtd; }
    { service = "storage"; cfgFile = configStorage; }
  ];

  # functions to generate systemd.service entries

  systemdEntry = service: cfgFile: (mapAttrs' ( name: cfg:
    (nameValuePair "beegfs-${service}-${name}" (mkIf cfg."${service}".enable {
    wantedBy = [ "multi-user.target" ];
    requires = [ "network-online.target" ];
    after = [ "network-online.target" ];
    serviceConfig = rec {
      ExecStart = ''
        ${pkgs.beegfs}/bin/beegfs-${service} \
          cfgFile=${cfgFile name cfg} \
          pidFile=${PIDFile}
      '';
      PIDFile = "/run/beegfs-${service}-${name}.pid";
      TimeoutStopSec = "300";
    };
  }))) cfg);

  systemdHelperd =  mapAttrs' ( name: cfg:
    (nameValuePair "beegfs-helperd-${name}" (mkIf cfg.client.enable {
    wantedBy = [ "multi-user.target" ];
    requires = [ "network-online.target" ];
    after = [ "network-online.target" ];
    serviceConfig = rec {
      ExecStart = ''
        ${pkgs.beegfs}/bin/beegfs-helperd \
          cfgFile=${configHelperd name cfg} \
          pidFile=${PIDFile}
      '';
      PIDFile = "/run/beegfs-helperd-${name}.pid";
      TimeoutStopSec = "300";
    };
   }))) cfg;

  # wrappers to beegfs tools. Avoid typing path of config files
  utilWrappers = mapAttrsToList ( name: cfg:
    ( pkgs.runCommand "beegfs-utils-${name}" {
        nativeBuildInputs = [ pkgs.makeWrapper ];
        preferLocalBuild = true;
        } ''
        mkdir -p $out/bin

        makeWrapper ${pkgs.beegfs}/bin/beegfs-check-servers \
                    $out/bin/beegfs-check-servers-${name} \
                    --add-flags "-c ${configClientFilename name}" \
                    --prefix PATH : ${lib.makeBinPath [ pkgs.beegfs ]}

        makeWrapper ${pkgs.beegfs}/bin/beegfs-ctl \
                    $out/bin/beegfs-ctl-${name} \
                    --add-flags "--cfgFile=${configClientFilename name}"

        makeWrapper ${pkgs.beegfs}/bin/beegfs-ctl \
                    $out/bin/beegfs-df-${name} \
                    --add-flags "--cfgFile=${configClientFilename name}" \
                    --add-flags --listtargets  \
                    --add-flags --hidenodeid \
                    --add-flags --pools \
                    --add-flags --spaceinfo

        makeWrapper ${pkgs.beegfs}/bin/beegfs-fsck \
                    $out/bin/beegfs-fsck-${name} \
                    --add-flags "--cfgFile=${configClientFilename name}"
      ''
     )) cfg;
in
{
  ###### interface

  options = {
    services.beegfsEnable = mkEnableOption "BeeGFS";

    services.beegfs = mkOption {
      default = {};
      description = ''
        BeeGFS configurations. Every mount point requires a separate configuration.
      '';
      type = with types; attrsOf (submodule ({ ... } : {
        options = {
          mgmtdHost = mkOption {
            type = types.str;
            default = null;
            example = "master";
            description = ''Hostname of managament host.'';
          };

          connAuthFile = mkOption {
            type = types.str;
            default = "";
            example = "/etc/my.key";
            description = "File containing shared secret authentication.";
          };

          connPortShift = mkOption {
            type = types.int;
            default = 0;
            example = 5;
            description = ''
              For each additional beegfs configuration shift all
              service TCP/UDP ports by at least 5.
            '';
          };

          client = {
            enable = mkEnableOption "BeeGFS client";

            mount = mkOption {
              type = types.bool;
              default = true;
              description = "Create fstab entry automatically";
            };

            mountPoint = mkOption {
              type = types.str;
              default = "/run/beegfs";
              description = ''
                Mount point under which the beegfs filesytem should be mounted.
                If mounted manually the mount option specifing the config file is needed:
                cfgFile=/etc/beegfs/beegfs-client-&lt;name&gt;.conf
              '';
            };

            extraConfig = mkOption {
              type = types.lines;
              default = "";
              description = ''
                Additional lines for beegfs-client.conf.
                See documentation for further details.
             '';
            };
          };

          helperd = {
            enable = mkOption {
              type = types.bool;
              default = true;
              description = ''
                Enable the BeeGFS helperd.
                The helpered is need for logging purposes on the client.
                Disabling <literal>helperd</literal> allows for runing the client
                with <literal>allowUnfree = false</literal>.
              '';
            };

            extraConfig = mkOption {
              type = types.lines;
              default = "";
              description = ''
                Additional lines for beegfs-helperd.conf. See documentation
                for further details.
              '';
            };
          };

          mgmtd = {
            enable = mkEnableOption "BeeGFS mgmtd daemon";

            storeDir = mkOption {
              type = types.path;
              default = null;
              example = "/data/beegfs-mgmtd";
              description = ''
                Data directory for mgmtd.
                Must not be shared with other beegfs daemons.
                This directory must exist and it must be initialized
                with beegfs-setup-mgmtd, e.g. "beegfs-setup-mgmtd -C -p &lt;storeDir&gt;"
              '';
            };

            extraConfig = mkOption {
              type = types.lines;
              default = "";
              description = ''
                Additional lines for beegfs-mgmtd.conf. See documentation
                for further details.
              '';
            };
          };

          admon = {
            enable = mkEnableOption "BeeGFS admon daemon";

            extraConfig = mkOption {
              type = types.lines;
              default = "";
              description = ''
                Additional lines for beegfs-admon.conf. See documentation
                for further details.
              '';
            };
          };

          meta = {
            enable = mkEnableOption "BeeGFS meta data daemon";

            storeDir = mkOption {
              type = types.path;
              default = null;
              example = "/data/beegfs-meta";
              description = ''
                Data directory for meta data service.
                Must not be shared with other beegfs daemons.
                The underlying filesystem must be mounted with xattr turned on.
                This directory must exist and it must be initialized
                with beegfs-setup-meta, e.g.
                "beegfs-setup-meta -C -s &lt;serviceID&gt; -p &lt;storeDir&gt;"
              '';
            };

            extraConfig = mkOption {
              type = types.str;
              default = "";
              description = ''
                Additional lines for beegfs-meta.conf. See documentation
                for further details.
              '';
            };
          };

          storage = {
            enable = mkEnableOption "BeeGFS storage daemon";

            storeDir = mkOption {
              type = types.path;
              default = null;
              example = "/data/beegfs-storage";
              description = ''
                Data directories for storage service.
                Must not be shared with other beegfs daemons.
                The underlying filesystem must be mounted with xattr turned on.
                This directory must exist and it must be initialized
                with beegfs-setup-storage, e.g.
                "beegfs-setup-storage -C -s &lt;serviceID&gt; -i &lt;storageTargetID&gt; -p &lt;storeDir&gt;"
              '';
            };

            extraConfig = mkOption {
              type = types.str;
              default = "";
              description = ''
                Addional lines for beegfs-storage.conf. See documentation
                for further details.
              '';
            };
          };
        };
      }));
    };
  };

  ###### implementation

  config =
    mkIf config.services.beegfsEnable {

    environment.systemPackages = utilWrappers;

    # Put the client.conf files in /etc since they are needed
    # by the commandline tools
    environment.etc = mapAttrs' ( name: cfg:
      (nameValuePair "beegfs/client-${name}.conf" (mkIf (cfg.client.enable)
    {
      enable = true;
      text = configClient name cfg;
    }))) cfg;

    # Kernel module, we need it only once per host.
    boot = mkIf (
      foldr (a: b: a || b) false
        (map (x: x.client.enable) (collect (x: x ? client) cfg)))
    {
      kernelModules = [ "beegfs" ];
      extraModulePackages = [ pkgs.linuxPackages.beegfs-module ];
    };

    # generate fstab entries
    fileSystems = mapAttrs' (name: cfg:
      (nameValuePair cfg.client.mountPoint (optionalAttrs cfg.client.mount (mkIf cfg.client.enable {
      device = "beegfs_nodev";
      fsType = "beegfs";
      mountPoint = cfg.client.mountPoint;
      options = [ "cfgFile=${configClientFilename name}" "_netdev" ];
    })))) cfg;

    # generate systemd services
    systemd.services = systemdHelperd //
      foldr (a: b: a // b) {}
        (map (x: systemdEntry x.service x.cfgFile) serviceList);
  };
}
