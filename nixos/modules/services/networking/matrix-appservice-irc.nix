{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.matrix-appservice-irc;
  boolToStr = b: if b then "true" else "false";
  mkRoom = r: ''{
    room: "${r.room}",
    ircToMatrix: {
      initial: ${boolToStr r.ircToMatrix.initial},
      incremental: ${boolToStr r.ircToMatrix.incremental}
    }
  }'';
  mkChannel = c: ''{
    room: "${c.channel}",
    ircToMatrix: {
      initial: ${boolToStr c.matrixToIrc.initial},
      incremental: ${boolToStr c.matrixToIrc.incremental}
    }
  }'';
  mkServer = address: s: ''"${address}": {
    port: ${toString s.port},
    ssl: ${boolToStr s.ssl},
    sslselfsign: ${boolToStr s.sslselfsign},
    ${optionalString (s.password != null) ''
    password: "${s.password}",
    ''}
    sendConnectionMessages: ${boolToStr s.sendConnectionMessages},
    botConfig: {
      enabled: ${boolToStr s.botConfig_enabled},
      nick: "${s.botConfig_nick}",
      ${optionalString (s.botConfig_password != null) ''
      password: "${s.botConfig_password}",
      ''}
      joinChannelsIfNoUsers: ${boolToStr s.botConfig_joinChannelsIfNoUsers}
    },
    privateMessages: {
      enabled: ${boolToStr s.privateMessages_enabled}
    },
    dynamicChannels: {
      enabled: ${boolToStr s.dynamicChannels_enabled},
      createAlias: ${boolToStr s.dynamicChannels_createAlias},
      published: ${boolToStr s.dynamicChannels_published},
      joinRule: "${s.dynamicChannels_joinRule}",
      federate: ${boolToStr s.dynamicChannels_federate},
      aliasTemplate: "${s.dynamicChannels_aliasTemplate}",
      whitelist: ${builtins.toJSON s.dynamicChannels_whitelist},
      exclude: ${builtins.toJSON s.dynamicChannels_exclude}
    },
    membershipLists: {
      enabled: ${boolToStr s.membershipLists_enabled},
      global: {
        ircToMatrix: {
          initial: ${boolToStr s.membershipLists_global_ircToMatrix.initial},
          incremental: ${boolToStr s.membershipLists_global_ircToMatrix.incremental}
        },
        matrixToIrc: {
          initial: ${boolToStr s.membershipLists_global_matrixToIrc.initial},
          incremental: ${boolToStr s.membershipLists_global_matrixToIrc.incremental}
        }
      },
      rooms: [ ${concatStringsSep "," (map mkRoom s.membershipLists_rooms)} ],
      channels: [ ${concatStringsSep "," (map mkChannel s.membershipLists_channels)} ]
    },
    mappings: ${builtins.toJSON s.mappings},
    matrixClients: {
      userTemplate: "${s.matrixClients_userTemplate}",
      displayName: "${s.matrixClients_displayName}"
    },
    ircClients: {
      nickTemplate: "${s.ircClients_nickTemplate}",
      allowNickChanges: ${boolToStr s.ircClients_allowNickChanges},
      maxClients: ${toString s.ircClients_maxClients},
      ${optionalString (s.ircClients_ipv6_prefix != null) ''
      ipv6: {
        prefix: "${s.ircClients_ipv6_prefix}"
      },
      ''}
      idleTimeout: ${toString s.ircClients_idleTimeout}
    }
  }'';
  configFile = pkgs.writeText "config.yaml" ''
  homeserver:
    url: "${cfg.homeserver_url}"
    domain: "${cfg.homeserver_domain}"
  ircService:
    ident:
      enabled: ${boolToStr cfg.ident_enabled}
      port: ${toString cfg.ident_port}
    logging:
      level: "${cfg.logging_level}"
      ${optionalString (cfg.logging_logfile != null) ''logfile: ${cfg.logging_logfile}''}
      ${optionalString (cfg.logging_errfile != null) ''errfile: ${cfg.logging_errfile}''}
      toConsole: ${boolToStr cfg.logging_toConsole}
      maxFileSizeBytes: ${toString cfg.logging_maxFileSizeBytes}
      maxFiles: ${toString cfg.logging_maxFiles}
    databaseUri: "${cfg.databaseUri}"
    servers: { ${concatStringsSep "," (mapAttrsToList mkServer cfg.servers)} }
    ${optionalString (cfg.statsd != null) ''
    statsd:
      hostname: "${cfg.statsd.hostname}"
      port: ${toString cfg.statsd.port}
      jobName: "${cfg.statsd.jobName}"
    ''}
  '';
  registration = pkgs.runCommand "app-service-irc-config.yaml" { preferLocalBuild = true; } ''
    cd ${pkgs.matrix-appservice-irc}/lib/node_modules/matrix-appservice-irc
    ${pkgs.matrix-appservice-irc}/bin/matrix-appservice-irc -r -f $out -u ${cfg.url} -c ${configFile} -l ircbot
  '';
  matrixToIrc = types.submodule {
    options = {
      initial = mkOption {
        type = types.bool;
        description = ''
          Get a snapshot of all real Matrix users in the room and join all of them
          to the mapped IRC channel on startup.
        '';
        default = false;
      };
      incremental = mkOption {
        type = types.bool;
        description = ''
          Make virtual IRC clients join and leave channels as their real Matrix
          counterparts join/leave rooms. Make sure your 'maxClients' value is
          high enough!
        '';
        default = false;
      };
    };
  };
  ircToMatrix = types.submodule {
    options = {
      initial = mkOption {
        type = types.bool;
        description = ''
          Get a snapshot of all real IRC users on a channel (via NAMES) and join
          their virtual matrix clients to the room.
        '';
        default = false;
      };
      incremental = mkOption {
        type = types.bool;
        description = ''
          Make virtual matrix clients join and leave rooms as their real IRC
          counterparts join/point channels.
        '';
        default = false;
      };
    };
  };
in {
  options = {
    services.matrix-appservice-irc = rec {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to run matrix-appservice-irc service.
        '';
      };
      url = mkOption {
        type = types.str;
        description = ''
          The URL matrix-appservice-irc listens on.
        '';
        default = "http://localhost:7555";
      };
      port = mkOption {
        type = types.int;
        description = ''
          The port matrix-appservice-irc listens on.
        '';
        default = 7555;
      };
      homeserver_url = mkOption {
        type = types.str;
        description = "The URL to the home server for client-server API calls.";
        default = "http://localhost:8008";
      };
      homeserver_domain = mkOption {
        type = types.str;
        description = ''
          The 'domain' part of the user IDs of this home server.
          Usually (but not always) is the 'domain name' part of the HS URL.
        '';
      };
      servers = mkOption {
        type = types.attrsOf (types.submodule { options = {
          port = mkOption {
            type = types.int;
            description = ''
              The port to connect to.
            '';
            default = 6697;
          };
          ssl = mkOption {
            type = types.bool;
            description = ''
              Whether to use SSL or not.
            '';
            default = true;
          };
          sslselfsign = mkOption {
            type = types.bool;
            description = ''
              Whether or not IRC server is using a self-signed cert or not
              providing CA chain
            '';
            default = false;
          };
          password = mkOption {
            type = types.nullOr types.str;
            description = ''
              The connection password to send for all clients as a PASS command.
            '';
            default = null;
          };
          sendConnectionMessages = mkOption {
            type = types.bool;
            description = ''
              Whether or not to send connection/error notices to real Matrix
              users.
            '';
            default = true;
          };
          botConfig_enabled = mkOption {
            type = types.bool;
            description = ''
              Enable the presence of the bot in IRC channels. The bot serves as
              the entity which maps from IRC -&gt; Matrix. You can disable the bot
              entirely which means IRC -&gt; Matrix chat will be shared by active
              "M-Nick" connections in the room. If there are no users in the
              room (or if there are users but their connections are not on IRC)
              then nothing will be bridged to Matrix. If you're concerned about
              the bot being treated as a "logger" entity, then you may want to
              disable the bot. If you want IRC-&gt;Matrix but don't want to have
              TCP connections to IRC unless a Matrix user speaks (because your
              client connection limit is low), then you may want to keep the bot
              enabled.
              NB: If the bot is disabled, you SHOULD have matrix-to-IRC syncing
                  turned on, else there will be no users and no bot in a channel
                  (meaning no messages to Matrix!) until a Matrix user speaks
                  which makes a client join the target IRC channel.
            '';
            default = true;
          };
          botConfig_nick = mkOption {
            type = types.str;
            description = ''
              The nickname to give to the AS bot.
            '';
            default = "MatrixBot";
          };
          botConfig_password = mkOption {
            type = types.nullOr types.str;
            description = ''
              The password to give to NickServ or IRC Server for this nick.
            '';
            default = null;
          };
          botConfig_joinChannelsIfNoUsers = mkOption {
            type = types.bool;
            description = ''
              Join channels even if there are no Matrix users on the other side
              of the bridge. Set to false to prevent the bot from joining
              channels which have no real matrix users in them, even if there
              is a mapping for the channel.
            '';
            default = true;
          };
          privateMessages_enabled = mkOption {
            type = types.bool;
            description = ''
              Enable the ability for PMs to be sent to/from IRC/Matrix.
            '';
            default = true;
          };
          dynamicChannels_enabled = mkOption {
            type = types.bool;
            description = ''
              Enable the ability for Matrix users to join *any* channel on this
              IRC network.
            '';
            default = true;
          };
          dynamicChannels_createAlias = mkOption {
            type = types.bool;
            description = ''
              Should the AS create a room alias for the new Matrix room? The
              form of the alias can be modified via 'aliasTemplate'.
            '';
            default = true;
          };
          dynamicChannels_published = mkOption {
            type = types.bool;
            description = ''
              Should the AS publish the new Matrix room to the public room list
              so anyone can see it?
            '';
            default = true;
          };
          dynamicChannels_joinRule = mkOption {
            type = types.enum ["public" "invite"];
            description = ''
              What should the join_rule be for the new Matrix room? If 'public',
              anyone can join the room. If 'invite', only users with an invite
              can join the room. Note that if an IRC channel has +k or +i set on
              it, join_rules will be set to 'invite' until these modes are
              removed.
            '';
            default = "public";
          };
          dynamicChannels_federate = mkOption {
            type = types.bool;
            description = ''
              Should created Matrix rooms be federated? If false, only users on
              the HS attached to this AS will be able to interact with this
              room.
            '';
            default = true;
          };
          dynamicChannels_aliasTemplate = mkOption {
            type = types.str;
            description = ''
              The room alias template to apply when creating new aliases. This
              only applies if createAlias is 'true'. The following variables are
              exposed:
              $SERVER =&gt; The IRC server address (e.g. "irc.example.com")
              $CHANNEL =&gt; The IRC channel (e.g. "#python")
              This MUST have $CHANNEL somewhere in it.
            '';
            default = "#irc_$SERVER_$CHANNEL";
            example = "#irc_$CHANNEL";
          };
          dynamicChannels_whitelist = mkOption {
            type = types.listOf types.str;
            description = ''
              A list of user IDs which the AS bot will send invites to in
              response to a !join. Only applies if joinRule is 'invite'.
            '';
            default = [];
            example = [ "@foo:example.com" "@bar:example.com" ];
          };
          dynamicChannels_exclude = mkOption {
            type = types.listOf types.str;
            description = ''
              Prevent the given list of channels from being mapped under any
              circumstances.
            '';
            default = [];
            example = [ "#foo" "#bar" ];
          };
          membershipLists_enabled = mkOption {
            type = types.bool;
            description = ''
              Enable the syncing of membership lists between IRC and Matrix.
              This can have a significant effect on performance on startup as the
              lists are synced. This must be enabled for anything else in this
              section to take effect.
            '';
            default = false;
          };
          membershipLists_global_ircToMatrix = mkOption {
            type = ircToMatrix;
            description = "Default IRC to Matrix rules";
          };
          membershipLists_global_matrixToIrc = mkOption {
            type = matrixToIrc;
            description = "Default Matrix to IRC rules";
          };
          membershipLists_rooms = mkOption {
           type = types.listOf (types.submodule { options = {
             room = mkOption {
               type = types.str;
               description = "The room to apply rules to";
             };
             matrixToIrc = mkOption {
               type = matrixToIrc;
               description = "The rules to apply";
             };
           };});
           description = ''
             Apply specific rules to Matrix rooms. Only matrix-to-IRC takes
             effect.
          '';
          default = [];
          };
          membershipLists_channels = mkOption {
           type = types.listOf (types.submodule { options = {
             channel = mkOption {
               type = types.str;
               description = "The channel to apply rules to";
             };
             ircToMatrix = mkOption {
               type = ircToMatrix;
               description = "The rules to apply";
             };
           };});
           description = ''
             Apply specific rules to IRC channels. Only IRC-to-matrix takes effect.
           '';
           default = [];
          };
          mappings = mkOption {
            type = types.attrsOf (types.listOf types.str);
            description = ''
              Mappings from IRC channels to room IDs on this IRC server.
            '';
            default = {};
            example = { "#example" = ["!kieouiJuedJoxtVdaG:example.com"]; };
          };
          matrixClients_userTemplate = mkOption {
            type = types.str;
            description = ''
              The user ID template to use when creating virtual matrix users.
              This MUST have $NICK somewhere in it. The following variables are
              exposed:
              $NICK =&gt; The IRC nick
              $SERVER =&gt; The IRC server address (e.g. "irc.example.com")
            '';
            default = "@irc_$NICK";
          };
          matrixClients_displayName = mkOption {
            type = types.str;
            description = ''
              The display name to use for created matrix clients. This should have
              $NICK somewhere in it if it is specified. Can also use $SERVER to
              insert the IRC domain. The following variables are exposed:
              $NICK =&gt; The IRC nick
              $SERVER =&gt; The IRC server address (e.g. "irc.example.com")
            '';
            default = "$NICK (IRC)";
          };
          ircClients_nickTemplate = mkOption {
            type = types.str;
            description = ''
              The template to apply to every IRC client nick. This MUST have
              either $DISPLAY or $USERID or $LOCALPART somewhere in it.
              The following variables are exposed:
              $LOCALPART =&gt; The user ID localpart ("alice" in @alice:localhost)
              $USERID    =&gt; The user ID
              $DISPLAY   =&gt; The display name of this user, with excluded
                            characters (e.g. space) removed. If the user has no
                            display name, this falls back to $LOCALPART.
            '';
            default = "$DISPLAY[m]";
          };
          ircClients_allowNickChanges = mkOption {
            type = types.bool;
            description = ''
              True to allow virtual IRC clients to change their nick on this
              server by issuing !nick &lt;server&gt; &lt;nick&gt; commands to the IRC AS bot.
              This is completely freeform: it will NOT follow the nickTemplate.
            '';
            default = true;
          };
          ircClients_maxClients = mkOption {
            type = types.int;
            description = ''
              The max number of IRC clients that will connect. If the limit is
              reached, the client that spoke the longest time ago will be
              disconnected and replaced.
            '';
            default = 30;
          };
          ircClients_ipv6_prefix = mkOption {
            type = types.nullOr types.str;
            description = ''
              [!]EXPERIMENTAL. THIS MAY NOT WORK.
              The IPv6 prefix to use for generating unique addresses for each
              connected user. If not specified, all users will connect from the
              same (default) address.
            '';
            example = "2001:0db8:85a3::";
            default = null;
          };
          ircClients_idleTimeout = mkOption {
            type = types.int;
            description = ''
              The maximum amount of time in seconds that the client can exist
              without sending another message before being disconnected. Use 0
              to not apply an idle timeout. This value is ignored if this IRC
              server is mirroring matrix membership lists to IRC.
            '';
            default = 172800;
          };
        };});
        description = ''
          Configuration for each bridged IRC server
        '';
      };
      ident_enabled = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Configuration for an ident server. If you are running a public bridge
          it is advised you setup an ident server so IRC mods can ban specific
          matrix users rather than the application service itself.

          True to listen for Ident requests and respond with the matrix user's
          user_id (converted to ASCII, respecting RFC 1413).
        '';
      };
      ident_port = mkOption {
        type = types.int;
        description = ''
          The port to listen on for incoming ident requests.
          Typical IRC servers expect this to be 113, but this service runs as non-root
          and cannot bind such a low port. The "cap_net_bind_service" capability or
          some form of forwarding may be used as a work-around.
        '';
        default = 1113;
      };
      logging_level = mkOption {
        type = types.enum ["error" "warn" "info" "debug"];
        description = ''
          Level to log on console/logfile. One of error|warn|info|debug
        '';
        default = "debug";
      };
      logging_logfile = mkOption {
        type = types.nullOr types.str;
        description = ''
          The file location to log to. This is relative to the project
          directory.
        '';
        default = null;
        example = "debug.log";
      };
      logging_errfile = mkOption {
        type = types.nullOr types.str;
        description = ''
          The file location to log errors to. This is relative to the project
          directory.
        '';
        default = null;
        example = "errors.log";
      };
      logging_toConsole = mkOption {
        type = types.bool;
        description = ''
          Whether to log to the console or not.
        '';
        default = true;
      };
      logging_maxFileSizeBytes = mkOption {
        type = types.int;
        description = ''
          The max size each file can get to in bytes before a new file is
          created.
        '';
        default = 134217728;
      };
      logging_maxFiles = mkOption {
        type = types.int;
        description = ''
          The max number of files to keep. Files will be overwritten eventually
          due to rotations.
        '';
        default = 5;
      };
      statsd = mkOption {
        type = types.nullOr (types.submodule {
          options = {
            hostname = mkOption {
              type = types.str;
              default = "localhost";
              description = "statsd server hostname";
            };
            port = mkOption {
              type = types.int;
              default = 9878;
              description = "statsd server port";
            };
            jobName = mkOption {
              type = types.str;
              default = "irc_bridge";
              description = "job name to use";
            };
          };
        });
        description = ''
          The endpoint for a statsd server. If not specified, stats will not
          be sent. Stats are sent as UDP.
        '';
        default = null;
      };
      databaseUri = mkOption {
        type = types.str;
        description = ''
          The nedb database URI to connect to. This is the name of the directory
          to dump .db files to. This is relative to the project directory.
        '';
        default = "nedb:///var/lib/matrix-appservice-irc/data";
      };
    };
  };

  config = mkIf cfg.enable {
    users.extraGroups.matrix-appservice-irc = { };
    users.extraUsers.matrix-appservice-irc = {
      group = "matrix-appservice-irc";
    };

    services.matrix-synapse.app_service_config_files = [
      registration
    ];
    systemd.services.matrix-appservice-irc = {
      after = [ "matrix-synapse.service" ];
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        mkdir -m 0700 -p /var/lib/matrix-appservice-irc
        chown matrix-appservice-irc:matrix-appservice-irc /var/lib/matrix-appservice-irc
      '';
      serviceConfig = {
        PermissionsStartOnly = true;
        ExecStart = "${pkgs.matrix-appservice-irc}/bin/matrix-appservice-irc -c ${configFile} -f ${registration} -p ${toString cfg.port}";
        WorkingDirectory = "${pkgs.matrix-appservice-irc}/lib/node_modules/matrix-appservice-irc";
        User = "matrix-appservice-irc";
        Group = "matrix-appservice-irc";
      };
    };
  };
}
