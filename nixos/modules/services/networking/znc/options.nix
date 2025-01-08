{ lib, config, ... }:

let

  cfg = config.services.znc;

  networkOpts = {
    options = {

      server = lib.mkOption {
        type = lib.types.str;
        example = "irc.libera.chat";
        description = ''
          IRC server address.
        '';
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 6697;
        description = ''
          IRC server port.
        '';
      };

      password = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = ''
          IRC server password, such as for a Slack gateway.
        '';
      };

      useSSL = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to use SSL to connect to the IRC server.
        '';
      };

      modules = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ "simple_away" ];
        example = lib.literalExpression ''[ "simple_away" "sasl" ]'';
        description = ''
          ZNC network modules to load.
        '';
      };

      channels = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [ "nixos" ];
        description = ''
          IRC channels to join.
        '';
      };

      hasBitlbeeControlChannel = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to add the special Bitlbee operations channel.
        '';
      };

      extraConf = lib.mkOption {
        default = "";
        type = lib.types.lines;
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

      useLegacyConfig = lib.mkOption {
        default = true;
        type = lib.types.bool;
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
        modules = lib.mkOption {
          type = lib.types.listOf lib.types.str;
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

        userModules = lib.mkOption {
          type = lib.types.listOf lib.types.str;
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

        userName = lib.mkOption {
          default = "znc";
          example = "johntron";
          type = lib.types.str;
          description = ''
            The user name used to log in to the ZNC web admin interface.
          '';
        };

        networks = lib.mkOption {
          default = { };
          type = with lib.types; attrsOf (submodule networkOpts);
          description = ''
            IRC networks to connect the user to.
          '';
          example = lib.literalExpression ''
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

        nick = lib.mkOption {
          default = "znc-user";
          example = "john";
          type = lib.types.str;
          description = ''
            The IRC nick.
          '';
        };

        passBlock = lib.mkOption {
          example = ''
            &lt;Pass password&gt;
               Method = sha256
               Hash = e2ce303c7ea75c571d80d8540a8699b46535be6a085be3414947d638e48d9e93
               Salt = l5Xryew4g*!oa(ECfX2o
            &lt;/Pass&gt;
          '';
          type = lib.types.str;
          description = ''
            Generate with {command}`nix-shell -p znc --command "znc --makepass"`.
            This is the password used to log in to the ZNC web admin interface.
            You can also set this through
            {option}`services.znc.config.User.<username>.Pass.Method`
            and co.
          '';
        };

        port = lib.mkOption {
          default = 5000;
          type = lib.types.port;
          description = ''
            Specifies the port on which to listen.
          '';
        };

        useSSL = lib.mkOption {
          default = true;
          type = lib.types.bool;
          description = ''
            Indicates whether the ZNC server should use SSL when listening on
            the specified port. A self-signed certificate will be generated.
          '';
        };

        uriPrefix = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          example = "/znc/";
          description = ''
            An lib.optional URI prefix for the ZNC web interface. Can be
            used to make ZNC available behind a reverse proxy.
          '';
        };

        extraZncConf = lib.mkOption {
          default = "";
          type = lib.types.lines;
          description = ''
            Extra config to `znc.conf` file.
          '';
        };
      };

    };
  };

  config = lib.mkIf cfg.useLegacyConfig {

    services.znc.config =
      let
        c = cfg.confOptions;
        # defaults here should override defaults set in the non-legacy part
        mkDefault = lib.mkOverride 900;
      in
      {
        LoadModule = lib.mkDefault c.modules;
        Listener.l = {
          Port = lib.mkDefault c.port;
          IPv4 = lib.mkDefault true;
          IPv6 = lib.mkDefault true;
          SSL = lib.mkDefault c.useSSL;
          URIPrefix = c.uriPrefix;
        };
        User.${c.userName} = {
          Admin = lib.mkDefault true;
          Nick = lib.mkDefault c.nick;
          AltNick = lib.mkDefault "${c.nick}_";
          Ident = lib.mkDefault c.nick;
          RealName = lib.mkDefault c.nick;
          LoadModule = lib.mkDefault c.userModules;
          Network = lib.mapAttrs (name: net: {
            LoadModule = lib.mkDefault net.modules;
            Server = lib.mkDefault "${net.server} ${lib.optionalString net.useSSL "+"}${toString net.port} ${net.password}";
            Chan =
              lib.optionalAttrs net.hasBitlbeeControlChannel { "&bitlbee" = lib.mkDefault { }; }
              // lib.listToAttrs (map (n: lib.nameValuePair "#${n}" (mkDefault { })) net.channels);
            extraConfig = if net.extraConf == "" then mkDefault null else net.extraConf;
          }) c.networks;
          extraConfig = [ c.passBlock ];
        };
        extraConfig = lib.optional (c.extraZncConf != "") c.extraZncConf;
      };
  };

  imports = [
    (lib.mkRemovedOptionModule [ "services" "znc" "zncConf" ] ''
      Instead of `services.znc.zncConf = "... foo ...";`, use
      `services.znc.configFile = pkgs.writeText "znc.conf" "... foo ...";`.
    '')
  ];
}
