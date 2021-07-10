{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.softether;

  package = cfg.package.override { dataDir = cfg.dataDir; };

  mkValue = type: value: { inherit type value; };

  encodeValue = {type, value}: lib.generators.mkValueStringDefault {} value;

  recurseEncode = v: builtins.concatLists (lib.attrsets.mapAttrsToList encode v);

  encode = name: value: {
    bool = encode name (mkValue "bool" value);
    int = encode name (mkValue "uint" value);
    string = encode name (mkValue "string" value);
    set =
      if value ? type && value ? value then [ "${value.type} ${name} ${encodeValue value}" ]
      else [ "declare ${name}" "{" ] ++ (map (c: "\t" + c) (recurseEncode value)) ++ [ "}" ];
  }.${builtins.typeOf value};


  softetherConf = {
    type = with lib.types; let
      valueType = nullOr (oneOf [
          bool
          ints.unsigned
          str
          (lazyAttrsOf valueType)
      ]) // {
        description = ''
          Recursive attribute set of null or boolean or unsigned int or string or typed definition set ({type="type", value=value})
        '';
      };
    in attrsOf valueType;
    generate = pkgs: name: value: pkgs.writeText name (lib.concatStringsSep "\n" (recurseEncode value));
  };
in
{

  ###### interface

  options = {

    services.softether = {

      enable = mkEnableOption "SoftEther VPN services";

      package = mkOption {
        type = types.package;
        default = pkgs.softether;
        defaultText = "pkgs.softether";
        description = ''
          softether derivation to use.
        '';
      };

      vpnserver = {
        enable = mkEnableOption "SoftEther VPN Server";
        settings = mkOption {
          type = softetherConf.type;
          example = literalExample ''
            { root = {
              ListenerList.Listener0 = {
                Enabled = true;
                Port = 5555;
              }
              VirtualHUB.DEFAULT = {
                Online = true;
                SecurityAccountDatabase.UserList.USer = {
                  AuthNtLmSecureHash = {type="byte"; value="iEb36u6PsRetBr3YMLdYbA==";};
                  AuthPassword = {type="byte"; value="nSBsqvVeSws6oSxE8RRdDAoWgAU=";};
                  AuthType = 1;
                };
              };
            }}
          '';
          description = ''
            Configuration for SoftEther vpnserver, see
            <link xlink:href="https://www.softether.org/4-docs/1-manual/3._SoftEther_VPN_Server_Manual/3.3_VPN_Server_Administration#3.3.7_Configuration_File"/>
            for details. The Nix vale declared here will be translated directly
            to the key-value format SoftEther expects.
            </para>
            <para>
            You can use
            <command>nix-instantiate --eval --strict '&lt;nixpkgs/nixos&gt;' -A config.services.softether.vpnserver.settings</command>
            to view the current value. By default it contains listeners on
            ports  443, 992, 1194, &amp; 5555.
            </para>
            <para>
            if you intend to update the configuration through this option, be
            sure to disable <option>services.softether.vpnserver.mutable</option>,
            otherwise, none of the changes here will be applied after the
            initial deploy.
          '';
        };
        mutable = mkOption {
          default = true;
          type = types.bool;
          description = ''
            Indicates whether to allow the contents of the
            <literal>dataDir</literal> directory to be changed by the user at
            run-time.
            </para>
            <para>
            If enabled, modifications to the vpnserver configuration after its
            initial creation are not overwritten by a NixOS rebuild. If
            disabled, the vpnserver configuration is rebuilt on every NixOS
            rebuild.
            </para>
            <para>
            If the user wants to manage the softether service using the
            <literal>vpncmd</literal> command, this option should be enabled.
          '';
        };
        configFile = mkOption {
          type = types.path;
          description = ''
            Configuration file for SoftEther vpnserver. It is recommended to
            use the <option>config</option> option insead.
            </para>
            <para>
            Setting this option will override any auto-generated config file
            through the <option>config</option> option.
          '';
        };
      };

      vpnbridge.enable = mkEnableOption "SoftEther VPN Bridge";

      vpnclient = {
        enable = mkEnableOption "SoftEther VPN Client";
        up = mkOption {
          type = types.lines;
          default = "";
          description = ''
            Shell commands executed when the Virtual Network Adapter(s) is/are starting.
          '';
        };
        down = mkOption {
          type = types.lines;
          default = "";
          description = ''
            Shell commands executed when the Virtual Network Adapter(s) is/are shutting down.
          '';
        };
      };

      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/softether";
        description = ''
          Data directory for SoftEther VPN.
        '';
      };

    };

  };

  ###### implementation

  config = mkIf cfg.enable (

    mkMerge [{
      environment.systemPackages = [ package ];

      systemd.services.softether-init = {
        description = "SoftEther VPN services initial task";
        wantedBy = [ "network.target" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = false;
        };
        script = ''
            for d in vpnserver vpnbridge vpnclient vpncmd; do
                if ! test -e ${cfg.dataDir}/$d; then
                    ${pkgs.coreutils}/bin/mkdir -m0700 -p ${cfg.dataDir}/$d
                    install -m0600 ${package}${cfg.dataDir}/$d/hamcore.se2 ${cfg.dataDir}/$d/hamcore.se2
                fi
            done
            rm -rf ${cfg.dataDir}/vpncmd/vpncmd
            ln -s ${package}${cfg.dataDir}/vpncmd/vpncmd ${cfg.dataDir}/vpncmd/vpncmd
        '';
      };
    }

    (mkIf (cfg.vpnserver.enable) {
      services.softether.vpnserver = {
        configFile = mkDefault (softetherConf.generate pkgs "vpn_server.config" cfg.vpnserver.settings);
        settings.root = {
          ServerConfiguration = mkDefault {};
          ListenerList = mkDefault {
            Listener0 = {
              Enabled = true;
              Port = 443;
            };
            Listener1 = {
              Enabled = true;
              Port = 992;
            };
            Listener2 = {
              Enabled = true;
              Port = 1194;
            };
            Listener3 = {
              Enabled = true;
              Port = 5555;
            };
          };
        };
      };
      systemd.services.vpnserver = {
        description = "SoftEther VPN Server";
        after = [ "softether-init.service" ];
        requires = [ "softether-init.service" ];
        wantedBy = [ "network.target" ];
        serviceConfig = {
          Type = "forking";
          ExecStart = "${package}/bin/vpnserver start";
          ExecStop = "${package}/bin/vpnserver stop";
        };
        preStart = ''
            cp ${optionalString (cfg.vpnserver.mutable) "--no-clobber"} ${cfg.vpnserver.configFile} ${cfg.dataDir}/vpnserver/vpn_server.config

            rm -rf ${cfg.dataDir}/vpnserver/vpnserver
            ln -s ${package}${cfg.dataDir}/vpnserver/vpnserver ${cfg.dataDir}/vpnserver/vpnserver
        '';
        postStop = ''
            rm -rf ${cfg.dataDir}/vpnserver/vpnserver
        '';
      };
    })

    (mkIf (cfg.vpnbridge.enable) {
      systemd.services.vpnbridge = {
        description = "SoftEther VPN Bridge";
        after = [ "softether-init.service" ];
        requires = [ "softether-init.service" ];
        wantedBy = [ "network.target" ];
        serviceConfig = {
          Type = "forking";
          ExecStart = "${package}/bin/vpnbridge start";
          ExecStop = "${package}/bin/vpnbridge stop";
        };
        preStart = ''
            rm -rf ${cfg.dataDir}/vpnbridge/vpnbridge
            ln -s ${package}${cfg.dataDir}/vpnbridge/vpnbridge ${cfg.dataDir}/vpnbridge/vpnbridge
        '';
        postStop = ''
            rm -rf ${cfg.dataDir}/vpnbridge/vpnbridge
        '';
      };
    })

    (mkIf (cfg.vpnclient.enable) {
      systemd.services.vpnclient = {
        description = "SoftEther VPN Client";
        after = [ "softether-init.service" ];
        requires = [ "softether-init.service" ];
        wantedBy = [ "network.target" ];
        serviceConfig = {
          Type = "forking";
          ExecStart = "${package}/bin/vpnclient start";
          ExecStop = "${package}/bin/vpnclient stop";
        };
        preStart = ''
            rm -rf ${cfg.dataDir}/vpnclient/vpnclient
            ln -s ${package}${cfg.dataDir}/vpnclient/vpnclient ${cfg.dataDir}/vpnclient/vpnclient
        '';
        postStart = ''
            sleep 1
            ${cfg.vpnclient.up}
        '';
        postStop = ''
            rm -rf ${cfg.dataDir}/vpnclient/vpnclient
            sleep 1
            ${cfg.vpnclient.down}
        '';
      };
      boot.kernelModules = [ "tun" ];
    })

  ]);

}
