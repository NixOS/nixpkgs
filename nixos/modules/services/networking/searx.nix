{ options, config, lib, pkgs, ... }:

with lib;

let
  runDir = "/run/searx";

  cfg = config.services.searx;

  settingsFile = pkgs.writeText "settings.yml"
    (builtins.toJSON cfg.settings);

  generateConfig = ''
    cd ${runDir}

    # write NixOS settings as JSON
    (
      umask 077
      cp --no-preserve=mode ${settingsFile} settings.yml
    )

    # substitute environment variables
    env -0 | while IFS='=' read -r -d ''' n v; do
      sed "s#@$n@#$v#g" -i settings.yml
    done
  '';

  settingType = with types; (oneOf
    [ bool int float str
      (listOf settingType)
      (attrsOf settingType)
    ]) // { description = "JSON value"; };

in

{

  imports = [
    (mkRenamedOptionModule
      [ "services" "searx" "configFile" ]
      [ "services" "searx" "settingsFile" ])
  ];

  ###### interface

  options = {

    services.searx = {

      enable = mkOption {
        type = types.bool;
        default = false;
        relatedPackages = [ "searx" ];
        description = "Whether to enable Searx, the meta search engine.";
      };

      environmentFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = ''
          Environment file (see <literal>systemd.exec(5)</literal>
          "EnvironmentFile=" section for the syntax) to define variables for
          Searx. This option can be used to safely include secret keys into the
          Searx configuration.
        '';
      };

      settings = mkOption {
        type = types.attrsOf settingType;
        default = { };
        example = literalExpression ''
          { server.port = 8080;
            server.bind_address = "0.0.0.0";
            server.secret_key = "@SEARX_SECRET_KEY@";

            engines = lib.singleton
              { name = "wolframalpha";
                shortcut = "wa";
                api_key = "@WOLFRAM_API_KEY@";
                engine = "wolframalpha_api";
              };
          }
        '';
        description = ''
          Searx settings. These will be merged with (taking precedence over)
          the default configuration. It's also possible to refer to
          environment variables
          (defined in <xref linkend="opt-services.searx.environmentFile"/>)
          using the syntax <literal>@VARIABLE_NAME@</literal>.
          <note>
            <para>
              For available settings, see the Searx
              <link xlink:href="https://searx.github.io/searx/admin/settings.html">docs</link>.
            </para>
          </note>
        '';
      };

      settingsFile = mkOption {
        type = types.path;
        default = "${runDir}/settings.yml";
        description = ''
          The path of the Searx server settings.yml file. If no file is
          specified, a default file is used (default config file has debug mode
          enabled). Note: setting this options overrides
          <xref linkend="opt-services.searx.settings"/>.
          <warning>
            <para>
              This file, along with any secret key it contains, will be copied
              into the world-readable Nix store.
            </para>
          </warning>
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.searx;
        defaultText = literalExpression "pkgs.searx";
        description = "searx package to use.";
      };

      runInUwsgi = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to run searx in uWSGI as a "vassal", instead of using its
          built-in HTTP server. This is the recommended mode for public or
          large instances, but is unecessary for LAN or local-only use.
          <warning>
            <para>
              The built-in HTTP server logs all queries by default.
            </para>
          </warning>
        '';
      };

      uwsgiConfig = mkOption {
        type = options.services.uwsgi.instance.type;
        default = { http = ":8080"; };
        example = literalExpression ''
          {
            disable-logging = true;
            http = ":8080";                   # serve via HTTP...
            socket = "/run/searx/searx.sock"; # ...or UNIX socket
            chmod-socket = "660";             # allow the searx group to read/write to the socket
          }
        '';
        description = ''
          Additional configuration of the uWSGI vassal running searx. It
          should notably specify on which interfaces and ports the vassal
          should listen.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    users.users.searx =
      { description = "Searx daemon user";
        group = "searx";
        isSystemUser = true;
      };

    users.groups.searx = { };

    systemd.services.searx-init = {
      description = "Initialise Searx settings";
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        User = "searx";
        RuntimeDirectory = "searx";
        RuntimeDirectoryMode = "750";
      } // optionalAttrs (cfg.environmentFile != null)
        { EnvironmentFile = builtins.toPath cfg.environmentFile; };
      script = generateConfig;
    };

    systemd.services.searx = mkIf (!cfg.runInUwsgi) {
      description = "Searx server, the meta search engine.";
      wantedBy = [ "network.target" "multi-user.target" ];
      requires = [ "searx-init.service" ];
      after = [ "searx-init.service" ];
      serviceConfig = {
        User  = "searx";
        Group = "searx";
        ExecStart = "${cfg.package}/bin/searx-run";
      } // optionalAttrs (cfg.environmentFile != null)
        { EnvironmentFile = builtins.toPath cfg.environmentFile; };
      environment.SEARX_SETTINGS_PATH = cfg.settingsFile;
    };

    systemd.services.uwsgi = mkIf (cfg.runInUwsgi)
      { requires = [ "searx-init.service" ];
        after = [ "searx-init.service" ];
      };

    services.searx.settings = {
      # merge NixOS settings with defaults settings.yml
      use_default_settings = mkDefault true;
    };

    services.uwsgi = mkIf (cfg.runInUwsgi) {
      enable = true;
      plugins = [ "python3" ];

      instance.type = "emperor";
      instance.vassals.searx = {
        type = "normal";
        strict = true;
        immediate-uid = "searx";
        immediate-gid = "searx";
        lazy-apps = true;
        enable-threads = true;
        module = "searx.webapp";
        env = [
          "SEARX_SETTINGS_PATH=${cfg.settingsFile}"
          # searxng compatiblity https://github.com/searxng/searxng/issues/1519
          "SEARXNG_SETTINGS_PATH=${cfg.settingsFile}"
        ];
        buffer-size = 32768;
        pythonPackages = self: [ cfg.package ];
      } // cfg.uwsgiConfig;
    };

  };

  meta.maintainers = with maintainers; [ rnhmjoj ];
}
