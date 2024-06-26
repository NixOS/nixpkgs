{ lib, config, ... }:

with lib;

let

  cfg = config.services.znc;

  networkOpts = {
    options = {

      server = mkOption {
        type = types.str;
        example = "irc.libera.chat";
        description = ''
          IRC server address.
        '';
      };

      port = mkOption {
        type = types.port;
        default = 6697;
        description = ''
          IRC server port.
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

      modules = mkOption {
        type = types.listOf types.str;
        default = [ "simple_away" ];
        example = literalExpression ''[ "simple_away" "sasl" ]'';
        description = ''
          ZNC network modules to load.
        '';
      };

      channels = mkOption {
        type = types.listOf types.str;
        default = [ ];
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
          Extra config for the network. Consider using
          {option}`services.znc.config` instead.
        '';
      };
    };
  };

in

{

  options = {
    services.znc = {

      useLegacyConfig = mkOption {
        default = true;
        type = types.bool;
        description = ''
          Whether to propagate the legacy options under
          {option}`services.znc.confOptions.*` to the znc config. If this
          is turned on, the znc config will contain a user with the default name
          "znc", global modules "webadmin" and "adminlog" will be enabled by
          default, and more, all controlled through the
          {option}`services.znc.confOptions.*` options.
          You can use {command}`nix-instantiate --eval --strict '<nixpkgs/nixos>' -A config.services.znc.config`
          to view the current value of the config.

          In any case, if you need more flexibility,
          {option}`services.znc.config` can be used to override/add to
          all of the legacy options.
        '';
      };

      confOptions = {
        modules = mkOption {
          type = types.listOf types.str;
          default = [
            "webadmin"
            "adminlog"
          ];
          example = [
            "partyline"
            "webadmin"
            "adminlog"
            "log"
          ];
          description = ''
            A list of modules to include in the `znc.conf` file.
          '';
        };

        userModules = mkOption {
          type = types.listOf types.str;
          default = [
            "chansaver"
            "controlpanel"
          ];
          example = [
            "chansaver"
            "controlpanel"
            "fish"
            "push"
          ];
          description = ''
            A list of user modules to include in the `znc.conf` file.
          '';
        };

        userName = mkOption {
          default = "znc";
          example = "johntron";
          type = types.str;
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
          example = literalExpression ''
            {
              "libera" = {
                server = "irc.libera.chat";
                port = 6697;
                useSSL = true;
                modules = [ "simple_away" ];
              };
            };
          '';
        };

        nick = mkOption {
          default = "znc-user";
          example = "john";
          type = types.str;
          description = ''
            The IRC nick.
          '';
        };

        passBlock = mkOption {
          example = ''
            &lt;Pass password&gt;
               Method = sha256
               Hash = e2ce303c7ea75c571d80d8540a8699b46535be6a085be3414947d638e48d9e93
               Salt = l5Xryew4g*!oa(ECfX2o
            &lt;/Pass&gt;
          '';
          type = types.str;
          description = ''
            Generate with {command}`nix-shell -p znc --command "znc --makepass"`.
            This is the password used to log in to the ZNC web admin interface.
            You can also set this through
            {option}`services.znc.config.User.<username>.Pass.Method`
            and co.
          '';
        };

        port = mkOption {
          default = 5000;
          type = types.port;
          description = ''
            Specifies the port on which to listen.
          '';
        };

        useSSL = mkOption {
          default = true;
          type = types.bool;
          description = ''
            Indicates whether the ZNC server should use SSL when listening on
            the specified port. A self-signed certificate will be generated.
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

  config = mkIf cfg.useLegacyConfig {

    services.znc.config =
      let
        c = cfg.confOptions;
        # defaults here should override defaults set in the non-legacy part
        mkDefault = mkOverride 900;
      in
      {
        LoadModule = mkDefault c.modules;
        Listener.l = {
          Port = mkDefault c.port;
          IPv4 = mkDefault true;
          IPv6 = mkDefault true;
          SSL = mkDefault c.useSSL;
          URIPrefix = c.uriPrefix;
        };
        User.${c.userName} = {
          Admin = mkDefault true;
          Nick = mkDefault c.nick;
          AltNick = mkDefault "${c.nick}_";
          Ident = mkDefault c.nick;
          RealName = mkDefault c.nick;
          LoadModule = mkDefault c.userModules;
          Network = mapAttrs (name: net: {
            LoadModule = mkDefault net.modules;
            Server = mkDefault "${net.server} ${optionalString net.useSSL "+"}${toString net.port} ${net.password}";
            Chan =
              optionalAttrs net.hasBitlbeeControlChannel { "&bitlbee" = mkDefault { }; }
              // listToAttrs (map (n: nameValuePair "#${n}" (mkDefault { })) net.channels);
            extraConfig = if net.extraConf == "" then mkDefault null else net.extraConf;
          }) c.networks;
          extraConfig = [ c.passBlock ];
        };
        extraConfig = optional (c.extraZncConf != "") c.extraZncConf;
      };
  };

  imports = [
    (mkRemovedOptionModule
      [
        "services"
        "znc"
        "zncConf"
      ]
      ''
        Instead of `services.znc.zncConf = "... foo ...";`, use
        `services.znc.configFile = pkgs.writeText "znc.conf" "... foo ...";`.
      ''
    )
  ];
}
