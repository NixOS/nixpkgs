{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.mosquitto;

  # note that mosquitto config parsing is very simplistic as of may 2021.
  # often times they'll e.g. strtok() a line, check the first two tokens, and ignore the rest.
  # there's no escaping available either, so we have to prevent any being necessary.
  str = types.strMatching "[^\r\n]*" // {
    description = "single-line string";
  };
  path = types.addCheck types.path (p: str.check "${p}");
  configKey = types.strMatching "[^\r\n\t ]+";
  optionType =
    with types;
    oneOf [
      str
      path
      bool
      int
    ]
    // {
      description = "string, path, bool, or integer";
    };
  optionToString =
    v:
    if isBool v then
      boolToString v
    else if path.check v then
      "${v}"
    else
      toString v;

  assertKeysValid =
    prefix: valid: config:
    mapAttrsToList (n: _: {
      assertion = valid ? ${n};
      message = "Invalid config key ${prefix}.${n}.";
    }) config;

  formatFreeform =
    {
      prefix ? "",
    }:
    mapAttrsToList (n: v: "${prefix}${n} ${optionToString v}");

  userOptions =
    with types;
    submodule {
      options = {
        password = mkOption {
          type = uniq (nullOr str);
          default = null;
          description = ''
            Specifies the (clear text) password for the MQTT User.
          '';
        };

        passwordFile = mkOption {
          type = uniq (nullOr path);
          example = "/path/to/file";
          default = null;
          description = ''
            Specifies the path to a file containing the
            clear text password for the MQTT user.
            The file is securely passed to mosquitto by
            leveraging systemd credentials. No special
            permissions need to be set on this file.
          '';
        };

        hashedPassword = mkOption {
          type = uniq (nullOr str);
          default = null;
          description = ''
            Specifies the hashed password for the MQTT User.
            To generate hashed password install the `mosquitto`
            package and use `mosquitto_passwd`, then extract
            the second field (after the `:`) from the generated
            file.
          '';
        };

        hashedPasswordFile = mkOption {
          type = uniq (nullOr path);
          example = "/path/to/file";
          default = null;
          description = ''
            Specifies the path to a file containing the
            hashed password for the MQTT user.
            To generate hashed password install the `mosquitto`
            package and use `mosquitto_passwd`, then remove the
            `username:` prefix from the generated file.
            The file is securely passed to mosquitto by
            leveraging systemd credentials. No special
            permissions need to be set on this file.
          '';
        };

        acl = mkOption {
          type = listOf str;
          example = [
            "read A/B"
            "readwrite A/#"
          ];
          default = [ ];
          description = ''
            Control client access to topics on the broker.
          '';
        };
      };
    };

  userAsserts =
    prefix: users:
    mapAttrsToList (n: _: {
      assertion = builtins.match "[^:\r\n]+" n != null;
      message = "Invalid user name ${n} in ${prefix}";
    }) users
    ++ mapAttrsToList (n: u: {
      assertion =
        count (s: s != null) [
          u.password
          u.passwordFile
          u.hashedPassword
          u.hashedPasswordFile
        ] <= 1;
      message = "Cannot set more than one password option for user ${n} in ${prefix}";
    }) users;

  listenerScope = index: "listener-${toString index}";
  userScope = prefix: index: "${prefix}-user-${toString index}";
  credentialID = prefix: credential: "${prefix}-${credential}";

  toScopedUsers =
    listenerScope: users:
    pipe users [
      attrNames
      (imap0 (
        index: user: nameValuePair user (users.${user} // { scope = userScope listenerScope index; })
      ))
      listToAttrs
    ];

  userCredentials =
    user: credentials:
    pipe credentials [
      (filter (credential: user.${credential} != null))
      (map (credential: "${credentialID user.scope credential}:${user.${credential}}"))
    ];
  usersCredentials =
    listenerScope: users: credentials:
    pipe users [
      (toScopedUsers listenerScope)
      (mapAttrsToList (_: user: userCredentials user credentials))
      concatLists
    ];
  systemdCredentials =
    listeners: listenerCredentials:
    pipe listeners [
      (imap0 (index: listener: listenerCredentials (listenerScope index) listener))
      concatLists
    ];

  makePasswordFile =
    listenerScope: users: path:
    let
      makeLines =
        store: file:
        let
          scopedUsers = toScopedUsers listenerScope users;
        in
        mapAttrsToList (
          name: user:
          ''addLine ${escapeShellArg name} "''$(systemd-creds cat ${credentialID user.scope store})"''
        ) (filterAttrs (_: user: user.${store} != null) scopedUsers)
        ++ mapAttrsToList (
          name: user:
          ''addFile ${escapeShellArg name} "''${CREDENTIALS_DIRECTORY}/${credentialID user.scope file}"''
        ) (filterAttrs (_: user: user.${file} != null) scopedUsers);
      plainLines = makeLines "password" "passwordFile";
      hashedLines = makeLines "hashedPassword" "hashedPasswordFile";
    in
    pkgs.writeScript "make-mosquitto-passwd" (
      ''
        #! ${pkgs.runtimeShell}

        set -eu

        file=${escapeShellArg path}

        rm -f "$file"
        touch "$file"

        addLine() {
          echo "$1:$2" >> "$file"
        }
        addFile() {
          if [ $(wc -l <"$2") -gt 1 ]; then
            echo "invalid mosquitto password file $2" >&2
            return 1
          fi
          echo "$1:$(cat "$2")" >> "$file"
        }
      ''
      + concatStringsSep "\n" (
        plainLines
        ++ optional (plainLines != [ ]) ''
          ${cfg.package}/bin/mosquitto_passwd -U "$file"
        ''
        ++ hashedLines
      )
    );

  authPluginOptions =
    with types;
    submodule {
      options = {
        plugin = mkOption {
          type = path;
          description = ''
            Plugin path to load, should be a `.so` file.
          '';
        };

        denySpecialChars = mkOption {
          type = bool;
          description = ''
            Automatically disallow all clients using `#`
            or `+` in their name/id.
          '';
          default = true;
        };

        options = mkOption {
          type = attrsOf optionType;
          description = ''
            Options for the auth plugin. Each key turns into a `auth_opt_*`
             line in the config.
          '';
          default = { };
        };
      };
    };

  authAsserts =
    prefix: auth:
    mapAttrsToList (n: _: {
      assertion = configKey.check n;
      message = "Invalid auth plugin key ${prefix}.${n}";
    }) auth;

  formatAuthPlugin =
    plugin:
    [
      "auth_plugin ${plugin.plugin}"
      "auth_plugin_deny_special_chars ${optionToString plugin.denySpecialChars}"
    ]
    ++ formatFreeform { prefix = "auth_opt_"; } plugin.options;

  freeformListenerKeys = {
    allow_anonymous = 1;
    allow_zero_length_clientid = 1;
    auto_id_prefix = 1;
    bind_interface = 1;
    cafile = 1;
    capath = 1;
    certfile = 1;
    ciphers = 1;
    "ciphers_tls1.3" = 1;
    crlfile = 1;
    dhparamfile = 1;
    http_dir = 1;
    keyfile = 1;
    max_connections = 1;
    max_qos = 1;
    max_topic_alias = 1;
    mount_point = 1;
    protocol = 1;
    psk_file = 1;
    psk_hint = 1;
    require_certificate = 1;
    socket_domain = 1;
    tls_engine = 1;
    tls_engine_kpass_sha1 = 1;
    tls_keyform = 1;
    tls_version = 1;
    use_identity_as_username = 1;
    use_subject_as_username = 1;
    use_username_as_clientid = 1;
  };

  listenerOptions =
    with types;
    submodule {
      options = {
        port = mkOption {
          type = port;
          description = ''
            Port to listen on. Must be set to 0 to listen on a unix domain socket.
          '';
          default = 1883;
        };

        address = mkOption {
          type = nullOr str;
          description = ''
            Address to listen on. Listen on `0.0.0.0`/`::`
            when unset.
          '';
          default = null;
        };

        authPlugins = mkOption {
          type = listOf authPluginOptions;
          description = ''
            Authentication plugin to attach to this listener.
            Refer to the [mosquitto.conf documentation](https://mosquitto.org/man/mosquitto-conf-5.html)
            for details on authentication plugins.
          '';
          default = [ ];
        };

        users = mkOption {
          type = attrsOf userOptions;
          example = {
            john = {
              password = "123456";
              acl = [ "readwrite john/#" ];
            };
          };
          description = ''
            A set of users and their passwords and ACLs.
          '';
          default = { };
        };

        omitPasswordAuth = mkOption {
          type = bool;
          description = ''
            Omits password checking, allowing anyone to log in with any user name unless
            other mandatory authentication methods (eg TLS client certificates) are configured.
          '';
          default = false;
        };

        acl = mkOption {
          type = listOf str;
          description = ''
            Additional ACL items to prepend to the generated ACL file.
          '';
          example = [
            "pattern read #"
            "topic readwrite anon/report/#"
          ];
          default = [ ];
        };

        settings = mkOption {
          type = submodule {
            freeformType = attrsOf optionType;
          };
          description = ''
            Additional settings for this listener.
          '';
          default = { };
        };
      };
    };

  listenerAsserts =
    prefix: listener:
    assertKeysValid "${prefix}.settings" freeformListenerKeys listener.settings
    ++ userAsserts prefix listener.users
    ++ imap0 (i: v: authAsserts "${prefix}.authPlugins.${toString i}" v) listener.authPlugins;

  formatListener =
    idx: listener:
    [
      "listener ${toString listener.port} ${toString listener.address}"
      "acl_file /etc/mosquitto/acl-${toString idx}.conf"
    ]
    ++ optional (!listener.omitPasswordAuth) "password_file ${cfg.dataDir}/passwd-${toString idx}"
    ++ formatFreeform { } listener.settings
    ++ concatMap formatAuthPlugin listener.authPlugins;

  freeformBridgeKeys = {
    bridge_alpn = 1;
    bridge_attempt_unsubscribe = 1;
    bridge_bind_address = 1;
    bridge_cafile = 1;
    bridge_capath = 1;
    bridge_certfile = 1;
    bridge_identity = 1;
    bridge_insecure = 1;
    bridge_keyfile = 1;
    bridge_max_packet_size = 1;
    bridge_outgoing_retain = 1;
    bridge_protocol_version = 1;
    bridge_psk = 1;
    bridge_require_ocsp = 1;
    bridge_tls_version = 1;
    cleansession = 1;
    idle_timeout = 1;
    keepalive_interval = 1;
    local_cleansession = 1;
    local_clientid = 1;
    local_password = 1;
    local_username = 1;
    notification_topic = 1;
    notifications = 1;
    notifications_local_only = 1;
    remote_clientid = 1;
    remote_password = 1;
    remote_username = 1;
    restart_timeout = 1;
    round_robin = 1;
    start_type = 1;
    threshold = 1;
    try_private = 1;
  };

  bridgeOptions =
    with types;
    submodule {
      options = {
        addresses = mkOption {
          type = listOf (submodule {
            options = {
              address = mkOption {
                type = str;
                description = ''
                  Address of the remote MQTT broker.
                '';
              };

              port = mkOption {
                type = port;
                description = ''
                  Port of the remote MQTT broker.
                '';
                default = 1883;
              };
            };
          });
          default = [ ];
          description = ''
            Remote endpoints for the bridge.
          '';
        };

        topics = mkOption {
          type = listOf str;
          description = ''
            Topic patterns to be shared between the two brokers.
            Refer to the [
            mosquitto.conf documentation](https://mosquitto.org/man/mosquitto-conf-5.html) for details on the format.
          '';
          default = [ ];
          example = [ "# both 2 local/topic/ remote/topic/" ];
        };

        settings = mkOption {
          type = submodule {
            freeformType = attrsOf optionType;
          };
          description = ''
            Additional settings for this bridge.
          '';
          default = { };
        };
      };
    };

  bridgeAsserts =
    prefix: bridge:
    assertKeysValid "${prefix}.settings" freeformBridgeKeys bridge.settings
    ++ [
      {
        assertion = length bridge.addresses > 0;
        message = "Bridge ${prefix} needs remote broker addresses";
      }
    ];

  formatBridge =
    name: bridge:
    [
      "connection ${name}"
      "addresses ${concatMapStringsSep " " (a: "${a.address}:${toString a.port}") bridge.addresses}"
    ]
    ++ map (t: "topic ${t}") bridge.topics
    ++ formatFreeform { } bridge.settings;

  freeformGlobalKeys = {
    allow_duplicate_messages = 1;
    autosave_interval = 1;
    autosave_on_changes = 1;
    check_retain_source = 1;
    connection_messages = 1;
    log_facility = 1;
    log_timestamp = 1;
    log_timestamp_format = 1;
    max_inflight_bytes = 1;
    max_inflight_messages = 1;
    max_keepalive = 1;
    max_packet_size = 1;
    max_queued_bytes = 1;
    max_queued_messages = 1;
    memory_limit = 1;
    message_size_limit = 1;
    persistence_file = 1;
    persistence_location = 1;
    persistent_client_expiration = 1;
    pid_file = 1;
    queue_qos0_messages = 1;
    retain_available = 1;
    set_tcp_nodelay = 1;
    sys_interval = 1;
    upgrade_outgoing_qos = 1;
    websockets_headers_size = 1;
    websockets_log_level = 1;
  };

  globalOptions = with types; {
    enable = mkEnableOption "the MQTT Mosquitto broker";

    package = mkPackageOption pkgs "mosquitto" { };

    bridges = mkOption {
      type = attrsOf bridgeOptions;
      default = { };
      description = ''
        Bridges to build to other MQTT brokers.
      '';
    };

    listeners = mkOption {
      type = listOf listenerOptions;
      default = [ ];
      description = ''
        Listeners to configure on this broker.
      '';
    };

    includeDirs = mkOption {
      type = listOf path;
      description = ''
        Directories to be scanned for further config files to include.
        Directories will processed in the order given,
        `*.conf` files in the directory will be
        read in case-sensitive alphabetical order.
      '';
      default = [ ];
    };

    logDest = mkOption {
      type = listOf (
        either path (enum [
          "stdout"
          "stderr"
          "syslog"
          "topic"
          "dlt"
        ])
      );
      description = ''
        Destinations to send log messages to.
      '';
      default = [ "stderr" ];
    };

    logType = mkOption {
      type = listOf (enum [
        "debug"
        "error"
        "warning"
        "notice"
        "information"
        "subscribe"
        "unsubscribe"
        "websockets"
        "none"
        "all"
      ]);
      description = ''
        Types of messages to log.
      '';
      default = [ ];
    };

    persistence = mkOption {
      type = bool;
      description = ''
        Enable persistent storage of subscriptions and messages.
      '';
      default = true;
    };

    dataDir = mkOption {
      default = "/var/lib/mosquitto";
      type = types.path;
      description = ''
        The data directory.
      '';
    };

    settings = mkOption {
      type = submodule {
        freeformType = attrsOf optionType;
      };
      description = ''
        Global configuration options for the mosquitto broker.
      '';
      default = { };
    };
  };

  globalAsserts =
    prefix: cfg:
    flatten [
      (assertKeysValid "${prefix}.settings" freeformGlobalKeys cfg.settings)
      (imap0 (n: l: listenerAsserts "${prefix}.listener.${toString n}" l) cfg.listeners)
      (mapAttrsToList (n: b: bridgeAsserts "${prefix}.bridge.${n}" b) cfg.bridges)
    ];

  formatGlobal =
    cfg:
    [
      "per_listener_settings true"
      "persistence ${optionToString cfg.persistence}"
    ]
    ++ map (d: if path.check d then "log_dest file ${d}" else "log_dest ${d}") cfg.logDest
    ++ map (t: "log_type ${t}") cfg.logType
    ++ formatFreeform { } cfg.settings
    ++ concatLists (imap0 formatListener cfg.listeners)
    ++ concatLists (mapAttrsToList formatBridge cfg.bridges)
    ++ map (d: "include_dir ${d}") cfg.includeDirs;

  configFile = pkgs.writeText "mosquitto.conf" (concatStringsSep "\n" (formatGlobal cfg));

in

{

  ###### Interface

  options.services.mosquitto = globalOptions;

  ###### Implementation

  config = mkIf cfg.enable {

    assertions = globalAsserts "services.mosquitto" cfg;

    systemd.services.mosquitto = {
      description = "Mosquitto MQTT Broker Daemon";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      serviceConfig = {
        Type = "notify";
        NotifyAccess = "main";
        User = "mosquitto";
        Group = "mosquitto";
        RuntimeDirectory = "mosquitto";
        WorkingDirectory = cfg.dataDir;
        Restart = "on-failure";
        ExecStart = "${cfg.package}/bin/mosquitto -c ${configFile}";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";

        # Credentials
        SetCredential =
          let
            listenerCredentials =
              listenerScope: listener:
              usersCredentials listenerScope listener.users [
                "password"
                "hashedPassword"
              ];
          in
          systemdCredentials cfg.listeners listenerCredentials;

        LoadCredential =
          let
            listenerCredentials =
              listenerScope: listener:
              usersCredentials listenerScope listener.users [
                "passwordFile"
                "hashedPasswordFile"
              ];
          in
          systemdCredentials cfg.listeners listenerCredentials;

        # Hardening
        CapabilityBoundingSet = "";
        DevicePolicy = "closed";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";
        ProtectSystem = "strict";
        ReadWritePaths = [
          cfg.dataDir
          "/tmp" # mosquitto_passwd creates files in /tmp before moving them
        ] ++ filter path.check cfg.logDest;
        ReadOnlyPaths = map (p: "${p}") (
          cfg.includeDirs
          ++ filter (v: v != null) (flatten [
            (map (l: [
              (l.settings.psk_file or null)
              (l.settings.http_dir or null)
              (l.settings.cafile or null)
              (l.settings.capath or null)
              (l.settings.certfile or null)
              (l.settings.crlfile or null)
              (l.settings.dhparamfile or null)
              (l.settings.keyfile or null)
            ]) cfg.listeners)
            (mapAttrsToList (_: b: [
              (b.settings.bridge_cafile or null)
              (b.settings.bridge_capath or null)
              (b.settings.bridge_certfile or null)
              (b.settings.bridge_keyfile or null)
            ]) cfg.bridges)
          ])
        );
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@resources"
        ];
        UMask = "0077";
      };
      preStart = concatStringsSep "\n" (
        imap0 (
          idx: listener:
          makePasswordFile (listenerScope idx) listener.users "${cfg.dataDir}/passwd-${toString idx}"
        ) cfg.listeners
      );
    };

    environment.etc = listToAttrs (
      imap0 (idx: listener: {
        name = "mosquitto/acl-${toString idx}.conf";
        value = {
          user = config.users.users.mosquitto.name;
          group = config.users.users.mosquitto.group;
          mode = "0400";
          text = (
            concatStringsSep "\n" (flatten [
              listener.acl
              (mapAttrsToList (n: u: [ "user ${n}" ] ++ map (t: "topic ${t}") u.acl) listener.users)
            ])
          );
        };
      }) cfg.listeners
    );

    users.users.mosquitto = {
      description = "Mosquitto MQTT Broker Daemon owner";
      group = "mosquitto";
      uid = config.ids.uids.mosquitto;
      home = cfg.dataDir;
      createHome = true;
    };

    users.groups.mosquitto.gid = config.ids.gids.mosquitto;

  };

  meta = {
    maintainers = with lib.maintainers; [ pennae ];
    doc = ./mosquitto.md;
  };
}
