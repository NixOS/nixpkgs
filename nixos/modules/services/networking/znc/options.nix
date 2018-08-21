{ lib, config, ... }:

with lib;

let

  cfg = config.services.znc;

  # Default user and pass:
  # un=znc
  # pw=nixospass

  defaultUserName = "znc";
  defaultPassBlock = "
        <Pass password>
                Method = sha256
                Hash = e2ce303c7ea75c571d80d8540a8699b46535be6a085be3414947d638e48d9e93
                Salt = l5Xryew4g*!oa(ECfX2o
        </Pass>
  ";

  # Keep znc.conf in nix store, then symlink or copy into `dataDir`, depending on `mutable`.
  mkZncConf = confOpts: ''
    Version = 1.6.3
    ${concatMapStrings (n: "LoadModule = ${n}\n") confOpts.modules}

    <Listener l>
            Port = ${toString confOpts.port}
            IPv4 = true
            IPv6 = true
            SSL = ${boolToString confOpts.useSSL}
            ${lib.optionalString (confOpts.uriPrefix != null) "URIPrefix = ${confOpts.uriPrefix}"}
    </Listener>

    <User ${confOpts.userName}>
            ${confOpts.passBlock}
            Admin = true
            Nick = ${confOpts.nick}
            AltNick = ${confOpts.nick}_
            Ident = ${confOpts.nick}
            RealName = ${confOpts.nick}
            ${concatMapStrings (n: "LoadModule = ${n}\n") confOpts.userModules}

            ${ lib.concatStringsSep "\n" (lib.mapAttrsToList (name: net: ''
              <Network ${name}>
                  ${concatMapStrings (m: "LoadModule = ${m}\n") net.modules}
                  Server = ${net.server} ${lib.optionalString net.useSSL "+"}${toString net.port} ${net.password}
                  ${concatMapStrings (c: "<Chan #${c}>\n</Chan>\n") net.channels}
                  ${lib.optionalString net.hasBitlbeeControlChannel ''
                    <Chan &bitlbee>
                    </Chan>
                  ''}
                  ${net.extraConf}
              </Network>
              '') confOpts.networks) }
    </User>
    ${confOpts.extraZncConf}
  '';

  zncConfFile = pkgs.writeTextFile {
    name = "znc.conf";
    text = if cfg.zncConf != ""
      then cfg.zncConf
      else mkZncConf cfg.confOptions;
  };

  networkOpts = {
    options = {
      server = mkOption {
        type = types.str;
        example = "chat.freenode.net";
        description = ''
          IRC server address.
        '';
      };

      port = mkOption {
        type = types.int;
        default = 6697;
        example = 6697;
        description = ''
          IRC server port.
        '';
      };

      userName = mkOption {
        default = "";
        example = "johntron";
        type = types.string;
        description = ''
          A nick identity specific to the IRC server.
        '';
      };

      password = mkOption {
        type = types.str;
        default = "";
        description = ''
          IRC server password, such as for a Slack gateway.
        '';
      };

      useSSL = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to use SSL to connect to the IRC server.
        '';
      };

      modulePackages = mkOption {
        type = types.listOf types.package;
        default = [];
        example = [ "pkgs.zncModules.push" "pkgs.zncModules.fish" ];
        description = ''
          External ZNC modules to build.
        '';
      };

      modules = mkOption {
        type = types.listOf types.str;
        default = [ "simple_away" ];
        example = literalExample "[ simple_away sasl ]";
        description = ''
          ZNC modules to load.
        '';
      };

      channels = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [ "nixos" ];
        description = ''
          IRC channels to join.
        '';
      };

      hasBitlbeeControlChannel = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to add the special Bitlbee operations channel.
        '';
      };

      extraConf = mkOption {
        default = "";
        type = types.lines;
        example = ''
          Encoding = ^UTF-8
          FloodBurst = 4
          FloodRate = 1.00
          IRCConnectEnabled = true
          Ident = johntron
          JoinDelay = 0
          Nick = johntron
        '';
        description = ''
          Extra config for the network.
        '';
      };
    };
  };

in

{

  ###### Interface

  options = {
    services.znc = {

      zncConf = mkOption {
        default = "";
        example = "See: http://wiki.znc.in/Configuration";
        type = types.lines;
        description = ''
          Config file as generated with `znc --makeconf` to use for the whole ZNC configuration.
          If specified, `confOptions` will be ignored, and this value, as-is, will be used.
          If left empty, a conf file with default values will be used.
        '';
      };


      confOptions = {
        modules = mkOption {
          type = types.listOf types.str;
          default = [ "webadmin" "adminlog" ];
          example = [ "partyline" "webadmin" "adminlog" "log" ];
          description = ''
            A list of modules to include in the `znc.conf` file.
          '';
        };

        userModules = mkOption {
          type = types.listOf types.str;
          default = [ "chansaver" "controlpanel" ];
          example = [ "chansaver" "controlpanel" "fish" "push" ];
          description = ''
            A list of user modules to include in the `znc.conf` file.
          '';
        };

        userName = mkOption {
          default = defaultUserName;
          example = "johntron";
          type = types.string;
          description = ''
            The user name used to log in to the ZNC web admin interface.
          '';
        };

        networks = mkOption {
          default = { };
          type = with types; attrsOf (submodule networkOpts);
          description = ''
            IRC networks to connect the user to.
          '';
          example = {
            "freenode" = {
              server = "chat.freenode.net";
              port = 6697;
              useSSL = true;
              modules = [ "simple_away" ];
            };
          };
        };

        nick = mkOption {
          default = "znc-user";
          example = "john";
          type = types.string;
          description = ''
            The IRC nick.
          '';
        };

        passBlock = mkOption {
          example = defaultPassBlock;
          type = types.string;
          description = ''
            Generate with `nix-shell -p znc --command "znc --makepass"`.
            This is the password used to log in to the ZNC web admin interface.
          '';
        };

        port = mkOption {
          default = 5000;
          example = 5000;
          type = types.int;
          description = ''
            Specifies the port on which to listen.
          '';
        };

        useSSL = mkOption {
          default = true;
          type = types.bool;
          description = ''
            Indicates whether the ZNC server should use SSL when listening on the specified port. A self-signed certificate will be generated.
          '';
        };

        uriPrefix = mkOption {
          type = types.nullOr types.str;
          default = null;
          example = "/znc/";
          description = ''
            An optional URI prefix for the ZNC web interface. Can be
            used to make ZNC available behind a reverse proxy.
          '';
        };

        extraZncConf = mkOption {
          default = "";
          type = types.lines;
          description = ''
            Extra config to `znc.conf` file.
          '';
        };
      };

    };
  };
}
