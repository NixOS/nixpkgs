{ lib, pkgs, config, ... }:

with lib;

let
  cfg = config.services.wiki-js;

  format = pkgs.formats.json { };

  configFile = format.generate "wiki-js.yml" cfg.settings;
in {
  options.services.wiki-js = {
    enable = mkEnableOption "wiki-js";

    environmentFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/root/wiki-js.env";
      description = lib.mdDoc ''
        Environment fiel to inject e.g. secrets into the configuration.
      '';
    };

    stateDirectoryName = mkOption {
      default = "wiki-js";
      type = types.str;
      description = lib.mdDoc ''
        Name of the directory in {file}`/var/lib`.
      '';
    };

    settings = mkOption {
      default = {};
      type = types.submodule {
        freeformType = format.type;
        options = {
          port = mkOption {
            type = types.port;
            default = 3000;
            description = lib.mdDoc ''
              TCP port the process should listen to.
            '';
          };

          bindIP = mkOption {
            default = "0.0.0.0";
            type = types.str;
            description = lib.mdDoc ''
              IPs the service should listen to.
            '';
          };

          db = {
            type = mkOption {
              default = "postgres";
              type = types.enum [ "postgres" "mysql" "mariadb" "mssql" ];
              description = ''
                Database driver to use for persistence. Please note that <literal>sqlite</literal>
                is currently not supported as the build process for it is currently not implemented
                in <package>pkgs.wiki-js</package> and it's not recommended by upstream for
                production use.
              '';
            };
            host = mkOption {
              type = types.str;
              example = "/run/postgresql";
              description = lib.mdDoc ''
                Hostname or socket-path to connect to.
              '';
            };
            db = mkOption {
              default = "wiki";
              type = types.str;
              description = lib.mdDoc ''
                Name of the database to use.
              '';
            };
          };

          logLevel = mkOption {
            default = "info";
            type = types.enum [ "error" "warn" "info" "verbose" "debug" "silly" ];
            description = lib.mdDoc ''
              Define how much detail is supposed to be logged at runtime.
            '';
          };

          offline = mkEnableOption "offline mode" // {
            description = ''
              Disable latest file updates and enable
              <link xlink:href="https://docs.requarks.io/install/sideload">sideloading</link>.
            '';
          };
        };
      };
      description = ''
        Settings to configure <package>wiki-js</package>. This directly
        corresponds to <link xlink:href="https://docs.requarks.io/install/config">the upstream configuration options</link>.

        Secrets can be injected via the environment by
        <itemizedlist>
          <listitem><para>specifying <xref linkend="opt-services.wiki-js.environmentFile"/>
          to contain secrets</para></listitem>
          <listitem><para>and setting sensitive values to <literal>$(ENVIRONMENT_VAR)</literal>
          with this value defined in the environment-file.</para></listitem>
        </itemizedlist>
      '';
    };
  };

  config = mkIf cfg.enable {
    services.wiki-js.settings.dataPath = "/var/lib/${cfg.stateDirectoryName}";
    systemd.services.wiki-js = {
      description = "A modern and powerful wiki app built on Node.js";
      documentation = [ "https://docs.requarks.io/" ];
      wantedBy = [ "multi-user.target" ];

      path = with pkgs; [ coreutils ];
      preStart = ''
        ln -sf ${configFile} /var/lib/${cfg.stateDirectoryName}/config.yml
        ln -sf ${pkgs.wiki-js}/server /var/lib/${cfg.stateDirectoryName}
        ln -sf ${pkgs.wiki-js}/assets /var/lib/${cfg.stateDirectoryName}
        ln -sf ${pkgs.wiki-js}/package.json /var/lib/${cfg.stateDirectoryName}/package.json
      '';

      serviceConfig = {
        EnvironmentFile = mkIf (cfg.environmentFile != null) cfg.environmentFile;
        StateDirectory = cfg.stateDirectoryName;
        WorkingDirectory = "/var/lib/${cfg.stateDirectoryName}";
        DynamicUser = true;
        PrivateTmp = true;
        ExecStart = "${pkgs.nodejs}/bin/node ${pkgs.wiki-js}/server";
      };
    };
  };

  meta.maintainers = with maintainers; [ ma27 ];
}
