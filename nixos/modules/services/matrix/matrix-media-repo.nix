{
  config,
  lib,
  options,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.services.matrix-media-repo;
  format = pkgs.formats.yaml { };

  filterRecursiveNull =
    o:
    if isAttrs o then
      mapAttrs (_: v: filterRecursiveNull v) (filterAttrs (_: v: v != null) o)
    else if isList o then
      map filterRecursiveNull (filter (v: v != null) o)
    else
      o;

  # remove null values from the final configuration
  finalSettings = filterRecursiveNull cfg.settings;
  configFile = format.generate "matrix-media-repo-config.yaml" finalSettings;
  configDir = pkgs.runCommandLocal "matrix-media-repo-build-config-dir" { } (
    ''
      mkdir -p $out
      ln -s ${configFile} $out/00_default.yaml
    ''
    + lib.strings.concatLines (lib.map (f: "ln -s ${f} $out/") cfg.extraConfigFiles)
  );
in
{
  options = {
    services.matrix-media-repo = {
      enable = mkEnableOption "matrix-media-repo, a highly configurable multi-domain media repository for Matrix. ";

      serviceUnit = lib.mkOption {
        type = lib.types.str;
        readOnly = true;
        description = ''
          The systemd unit (a service or a target) for other services to depend on if they
          need to be started after matrix-media-repo.

          This option is useful as the actual parent unit for all matrix-media-repo processes
          changes when configuring workers.
        '';
      };

      configFile = mkOption {
        type = types.path;
        readOnly = true;
        description = ''
          Path to the configuration file on the target system. Useful to configure e.g. workers
          that also need this.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.matrix-media-repo;
        defaultText = "\${pkgs.matrix-media-repo}";
        description = ''
          The package to use for matrix-media-repo.
        '';
      };

      settings = mkOption {
        default = { };
        description = ''
          The primary configuration. See the
          [sample configuration](https://github.com/t2bot/matrix-media-repo/blob/main/config.sample.yaml)
          for possible values.

          Secrets should be passed in by using the `extraConfigFiles` option.
        '';
        type =
          with types;
          submodule {
            freeformType = format.type;
            options = {
              # This is a reduced set of popular options and defaults
              # Do not add every available option here, they can be specified
              # by the user at their own discretion. This is a freeform type!
              repo.bindAddress = mkOption {
                description = ''
                  The address to which matrix-media-repo should bind.
                '';
                type = types.str;
                default = "127.0.0.1";
              };
              repo.port = mkOption {
                description = ''
                  The port at which matrix-media-repo should listen.
                '';
                type = types.port;
                default = 8000;
              };
              repo.logDirectory = mkOption {
                description = ''
                  Where to store the logs, relative to where the repo is started from. Logs will be automatically
                  rotated every day and held for 14 days. To disable the repo logging to files, set this to
                  "-" (including quotation marks).

                  Note: to change the log directory you'll have to restart the repository. This setting cannot be
                  live reloaded.
                '';
                type = types.str;
                default = "-";
              };
              repo.logLevel = mkOption {
                description = ''
                  The log level to log at. Note that this will need to be at least "info" to receive support.

                  Values (in increasing spam): panic | fatal | error | warn | info | debug | trace
                '';
                type = types.enum [
                  "panic"
                  "fatal"
                  "error"
                  "warn"
                  "info"
                  "debug"
                  "trace"
                ];
                default = "info";
              };
              database.postgres = mkOption {
                description = ''
                  The URI to the postgres database matrix-media-repo should use.
                '';
                type = types.str;
                example = "postgres://your_username:your_password@localhost/database_name?sslmode=disable";
              };
              homeservers = mkOption {
                description = ''
                  A list of home servers for which matrix-media-repo should serve media.
                '';
                default = [ ];
                type = types.listOf (
                  types.submodule {
                    freeformType = format.type;
                    options = {
                      name = mkOption {
                        description = ''
                          This should match the server_name of your homeserver, and the Host header
                          provided to the media repo.
                        '';
                        type = types.str;
                        example = "example.org";
                      };
                      csApi = mkOption {
                        description = ''
                          The base URL to where the homeserver can actually be reached by MMR.
                        '';
                        type = types.str;
                        example = "https://example.org/";
                      };
                      adminApiKind = mkOption {
                        description = ''
                          The admin API interface supported by the homeserver. MMR uses a subset of the admin API
                          during certain operations, like attempting to purge media from a room or validating server
                          admin status. This should be set to one of "synapse", "dendrite", or "matrix". When set
                          to "matrix", most functionality requiring the admin API will not work.
                        '';
                        type = types.enum [
                          "synapse"
                          "dendrite"
                          "matrix"
                        ];
                        default = "synapse";
                      };

                      signingKeyPath = mkOption {
                        description = ''
                          The signing key to use for authorizing outbound federation requests. If not specified,
                          requests will not be authorized. See https://docs.t2bot.io/matrix-media-repo/v1.3.5/installation/signing-key/
                          for details.
                        '';
                        type = types.nullOr types.path;
                        default = null;
                        example = "/data/example.org.key";
                      };
                    };
                  }
                );
              };
              admins = mkOption {
                description = ''
                  These users have full access to the administrative functions of the media repository.
                  See docs/admin.md for information on what these people can do. They must belong to one of the
                  configured homeservers above.
                '';
                type = types.listOf types.str;
                default = [ ];
              };
              datastores = mkOption {
                description = ''
                  A list of datastore backends in which matrix-media-repo should store media.
                '';
                type = types.listOf (
                  types.submodule {
                    freeformType = format.type;
                    options = {
                      type = mkOption {
                        description = ''
                          The type of the datastore backend.
                        '';
                        type = types.enum [
                          "file"
                          "s3"
                        ];
                      };
                      id = mkOption {
                        description = ''
                          ID for this datastore (cannot change). Alphanumeric recommended.
                        '';
                        type = types.str;
                      };
                      forKinds = mkOption {
                        description = ''
                          Datastores can be split into many areas when handling uploads. Media is still de-duplicated
                          across all datastores (local content which duplicates remote content will re-use the remote
                          content's location). This option is useful if your datastore is becoming very large, or if
                          you want faster storage for a particular kind of media.

                          To disable this datastore, making it readonly, specify `forKinds: []`.

                          The kinds available are:
                            thumbnails    - Used to store thumbnails of media (local and remote).
                            remote_media  - Original copies of remote media (servers not configured by this repo).
                            local_media   - Original uploads for local media.
                            archives      - Archives of content (GDPR and similar requests).
                        '';
                        type = types.listOf (
                          types.enum [
                            "thumbnails"
                            "remote_media"
                            "local_media"
                            "archives"
                          ]
                        );
                        default = [
                          "thumbnails"
                          "remote_media"
                          "local_media"
                          "archives"
                        ];
                        apply = lib.unique;
                      };
                      opts = mkOption {
                        description = ''
                          Datastore specific options
                        '';
                        type = types.submodule {
                          options = {
                            path = mkOption {
                              description = ''
                                In case of type=="file", this is the path to the datastore
                              '';
                              type = types.nullOr types.path;
                              default = null;
                            };
                          };
                        };
                      };
                    };
                  }
                );
              };
            };
          };
      };

      extraConfigFiles = mkOption {
        type = types.listOf types.path;
        default = [ ];
        description = ''
          Extra config files to include.

          The configuration files will be included based on the command line
          argument --config-path. This allows to configure secrets without
          having to go through the Nix store, e.g. based on deployment keys if
          NixOps is in use.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = builtins.all (d: d.type == "file" -> d.opts.path != null) cfg.settings.datastores;
        message = "services.matrix-media-repo.settings.datastores.<name>.opts.path must be set if datastore.type == \"file\"";
      }
    ];

    services.matrix-media-repo.serviceUnit = "matrix-media-repo.service";
    services.matrix-media-repo.configFile = configFile;

    users.users.matrix-media-repo = {
      group = "matrix-media-repo";
      home = "/var/empty";
      createHome = true;
      shell = "${pkgs.bash}/bin/bash";
      isSystemUser = true;
      # uid = config.ids.uids.matrix-media-repo;
    };

    users.groups.matrix-media-repo = {
      # gid = config.ids.gids.matrix-media-repo;
    };

    systemd.services.matrix-media-repo = {
      enable = true;
      description = "Highly configurable multi-domain media repository for Matrix.";

      serviceConfig =
        let
          datastorePaths = builtins.map (d: d.opts.path) (
            builtins.filter (d: d.type == "file") cfg.settings.datastores
          );
        in
        {
          Type = "simple";
          User = "matrix-media-repo";
          Group = "matrix-media-repo";
          RuntimeDirectory = "matrix-media-repo";
          RuntimeDirectoryPreserve = true;
          Restart = "on-failure";
          UMask = "0077";

          # Security Hardening
          # Refer to systemd.exec(5) for option descriptions.
          CapabilityBoundingSet = [ "" ];
          LockPersonality = true;
          NoNewPrivileges = true;
          PrivateDevices = true;
          PrivateTmp = true;
          PrivateUsers = true;
          ProcSubset = "pid";
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectHome = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectProc = "invisible";
          ReadWritePaths = datastorePaths;
          RemoveIPC = true;
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
            "AF_UNIX"
          ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;

          ExecStartPre = [
            (
              "+"
              + (pkgs.writeShellScript "matrix-media-repo-ensure-datastore-paths" (
                lib.strings.concatLines (
                  builtins.map (d: ''
                    mkdir -p ${d}
                    chown matrix-media-repo:matrix-media-repo ${d}
                    chmod 0770 ${d}
                  '') datastorePaths
                )
              ))
            )
          ];

          ExecStart = ''
            ${cfg.package}/bin/media_repo -config ${configDir}
          '';
        };
    };
  };
  meta = {
    maintainers = with lib.maintainers; [ lykos153 ];
  };
}
