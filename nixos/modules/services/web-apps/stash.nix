{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    getExe
    literalExpression
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    optionalString
    toUpper
    types
    ;

  cfg = config.services.stash;

  stashType = types.submodule {
    options = {
      path = mkOption {
        type = types.path;
        description = "location of your media files";
      };
      excludevideo = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to exclude video files from being scanned into Stash";
      };
      excludeimage = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to exclude image files from being scanned into Stash";
      };
    };
  };
  stashBoxType = types.submodule {
    options = {
      name = mkOption {
        type = types.str;
        description = "The name of the Stash Box";
      };
      endpoint = mkOption {
        type = types.str;
        description = "URL to the Stash Box graphql api";
      };
      apikey = mkOption {
        type = types.str;
        description = "Stash Box API key";
      };
    };
  };

  recentlyReleased = mode: {
    __typename = "CustomFilter";
    message = {
      id = "recently_released_objects";
      values.objects = mode;
    };
    mode = toUpper mode;
    sortBy = "date";
    direction = "DESC";
  };
  recentlyAdded = mode: {
    __typename = "CustomFilter";
    message = {
      id = "recently_added_objects";
      values.objects = mode;
    };
    mode = toUpper mode;
    sortBy = "created_at";
    direction = "DESC";
  };
  uiPresets = {
    recentlyReleasedScenes = recentlyReleased "Scenes";
    recentlyAddedScenes = recentlyAdded "Scenes";
    recentlyReleasedGalleries = recentlyReleased "Galleries";
    recentlyAddedGalleries = recentlyAdded "Galleries";
    recentlyAddedImages = recentlyAdded "Images";
    recentlyReleasedMovies = recentlyReleased "Movies";
    recentlyAddedMovies = recentlyAdded "Movies";
    recentlyAddedStudios = recentlyAdded "Studios";
    recentlyAddedPerformers = recentlyAdded "Performers";
  };

  settingsFormat = pkgs.formats.yaml { };
  settingsFile = settingsFormat.generate "config.yml" cfg.settings;
  settingsType = types.submodule {
    freeformType = settingsFormat.type;

    options = {
      host = mkOption {
        type = types.str;
        default = "localhost";
        example = "::1";
        description = "The ip address that Stash should bind to.";
      };

      port = mkOption {
        type = types.port;
        default = 9999;
        example = 1234;
        description = "The port that Stash should listen on.";
      };

      stash = mkOption {
        type = types.listOf stashType;
        description = ''
          Add directories containing your adult videos and images.
          Stash will use these directories to find videos and/or images during scanning.
        '';
        example = literalExpression ''
          {
            stash = [
              {
                Path = "/media/drive/videos";
                ExcludeImage = true;
              }
            ];
          }
        '';
      };
      stash_boxes = mkOption {
        type = types.listOf stashBoxType;
        default = [ ];
        description = ''Stash-box facilitates automated tagging of scenes and performers based on fingerprints and filenames'';
        example = literalExpression ''
          {
            stash_boxes = [
              {
                name = "StashDB";
                endpoint = "https://stashdb.org/graphql";
                apikey = "aaaaaaaaaaaa.bbbbbbbbbbbbbbbbbbbbbbbb.cccccccccccccc";
              }
            ];
          }
        '';
      };
      ui.frontPageContent = mkOption {
        description = "Search filters to display on the front page.";
        type = types.either (types.listOf types.attrs) (types.functionTo (types.listOf types.attrs));
        default = presets: [
          presets.recentlyReleasedScenes
          presets.recentlyAddedStudios
          presets.recentlyReleasedMovies
          presets.recentlyAddedPerformers
          presets.recentlyReleasedGalleries
        ];
        example = literalExpression ''
          presets: [
            # To get the savedFilterId, you can query `{ findSavedFilters(mode: <FilterMode>) { id name } }` on localhost:9999/graphql
            {
              __typename = "SavedFilter";
              savedFilterId = 1;
            }
            # basic custom filter
            {
              __typename = "CustomFilter";
              title = "Random Scenes";
              mode = "SCENES";
              sortBy = "random";
              direction = "DESC";
            }
            presets.recentlyAddedImages
          ]
        '';
        apply = type: if lib.isFunction type then (type uiPresets) else type;
      };
      blobs_path = mkOption {
        type = types.path;
        default = "${cfg.dataDir}/blobs";
        description = "Path to blobs";
      };
      cache = mkOption {
        type = types.path;
        default = "${cfg.dataDir}/cache";
        description = "Path to cache";
      };
      database = mkOption {
        type = types.path;
        default = "${cfg.dataDir}/go.sqlite";
        description = "Path to the SQLite database";
      };
      generated = mkOption {
        type = types.path;
        default = "${cfg.dataDir}/generated";
        description = "Path to generated files";
      };
      plugins_path = mkOption {
        type = types.path;
        default = "${cfg.dataDir}/plugins";
        description = "Path to scrapers";
      };
      scrapers_path = mkOption {
        type = types.path;
        default = "${cfg.dataDir}/scrapers";
        description = "Path to scrapers";
      };

      blobs_storage = mkOption {
        type = types.enum [
          "FILESYSTEM"
          "DATABASE"
        ];
        default = "FILESYSTEM";
        description = "Where to store blobs";
      };
      calculate_md5 = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to calculate MD5 checksums for scene video files";
      };
      create_image_clip_from_videos = mkOption {
        type = types.bool;
        default = false;
        description = "Create Image Clips from Video extensions when Videos are disabled in Library";
      };
      dangerous_allow_public_without_auth = mkOption {
        type = types.bool;
        default = false;
        description = "Learn more at <https://docs.stashapp.cc/networking/authentication-required-when-accessing-stash-from-the-internet/>";
      };
      gallery_cover_regex = mkOption {
        type = types.str;
        default = "(poster|cover|folder|board)\\.[^.]+$";
        description = "Regex used to identify images as gallery covers";
      };
      no_proxy = mkOption {
        type = types.str;
        default = "localhost,127.0.0.1,192.168.0.0/16,10.0.0.0/8,172.16.0.0/12";
        description = "A list of domains for which the proxy must not be used";
      };
      nobrowser = mkOption {
        type = types.bool;
        default = true;
        description = "If we should not auto-open a browser window on startup";
      };
      notifications_enabled = mkOption {
        type = types.bool;
        default = true;
        description = "If we should send notifications to the desktop";
      };
      parallel_tasks = mkOption {
        type = types.int;
        default = 1;
        description = "Number of parallel tasks to start during scan/generate";
      };
      preview_audio = mkOption {
        type = types.bool;
        default = true;
        description = "Include audio stream in previews";
      };
      preview_exclude_end = mkOption {
        type = types.int;
        default = 0;
        description = "Duration of start of video to exclude when generating previews";
      };
      preview_exclude_start = mkOption {
        type = types.int;
        default = 0;
        description = "Duration of end of video to exclude when generating previews";
      };
      preview_segment_duration = mkOption {
        type = types.float;
        default = 0.75;
        description = "Preview segment duration, in seconds";
      };
      preview_segments = mkOption {
        type = types.int;
        default = 12;
        description = "Number of segments in a preview file";
      };
      security_tripwire_accessed_from_public_internet = mkOption {
        type = types.nullOr types.str;
        default = "";
        description = "Learn more at <https://docs.stashapp.cc/networking/authentication-required-when-accessing-stash-from-the-internet/>";
      };
      sequential_scanning = mkOption {
        type = types.bool;
        default = false;
        description = "Modifies behaviour of the scanning functionality to generate support files (previews/sprites/phash) at the same time as fingerprinting/screenshotting";
      };
      show_one_time_moved_notification = mkOption {
        type = types.bool;
        default = true;
        description = "Whether a small notification to inform the user that Stash will no longer show a terminal window, and instead will be available in the tray";
      };
      sound_on_preview = mkOption {
        type = types.bool;
        default = false;
        description = "Enable sound on mouseover previews";
      };
      theme_color = mkOption {
        type = types.str;
        default = "#202b33";
        description = "Sets the `theme-color` property in the UI";
      };
      video_file_naming_algorithm = mkOption {
        type = types.enum [
          "OSHASH"
          "MD5"
        ];
        default = "OSHASH";
        description = "Hash algorithm to use for generated file naming";
      };
      write_image_thumbnails = mkOption {
        type = types.bool;
        default = true;
        description = "Write image thumbnails to disk when generating on the fly";
      };
    };
  };

  pluginType =
    kind:
    mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = ''
        The ${kind} Stash should be started with.
      '';
      apply =
        srcs:
        pkgs.runCommand "stash-${kind}"
          {
            inherit srcs;
            nativeBuildInputs = [ pkgs.yq-go ];

          }
          ''
            mkdir -p $out
            touch $out/.keep
            find $srcs -mindepth 1 -name '*.yml' | while read plugin_file; do
              grep -q "^#pkgignore" "$plugin_file" && continue

              plugin_dir=$(dirname $plugin_file)
              out_path=$out/$(basename $plugin_dir)
              mkdir -p $out_path
              ls $plugin_dir | xargs -I{} ln -sf "$plugin_dir/{}" $out_path

              env \
                plugin_id=$(basename $plugin_file .yml) \
                plugin_name="$(yq '.name' $plugin_file)" \
                plugin_description="$(yq '.description' $plugin_file)" \
                plugin_version="$(yq '.version' $plugin_file)" \
                plugin_files="$(find -L $out_path -mindepth 1 -type f -printf "%P\n")" \
                yq -n '
                  .id = strenv(plugin_id) |
                  .name = strenv(plugin_name) |
                  (
                    strenv(plugin_description) as $desc |
                    with(select($desc == "null"); .metadata = {}) |
                    with(select($desc != "null"); .metadata.description = $desc)
                  ) |
                  (
                    strenv(plugin_version) as $ver |
                    with(select($ver == "null"); .version = "Unknown") |
                    with(select($ver != "null"); .version = $ver)
                  ) |
                  .date = (now | format_datetime("2006-01-02 15:04:05")) |
                  .files = (strenv(plugin_files) | split("\n"))
                ' > $out_path/manifest
            done
          '';
    };
in
{
  meta = {
    buildDocsInSandbox = false;
    maintainers = with lib.maintainers; [ DrakeTDL ];
  };

  options = {
    services.stash = {
      enable = mkEnableOption "stash";

      package = mkPackageOption pkgs "stash" { };

      user = mkOption {
        type = types.str;
        default = "stash";
        description = "User under which Stash runs.";
      };

      group = mkOption {
        type = types.str;
        default = "stash";
        description = "Group under which Stash runs.";
      };

      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/stash";
        description = "The directory where Stash stores its files.";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = "Open ports in the firewall for the Stash web interface.";
      };

      username = mkOption {
        type = types.nullOr types.nonEmptyStr;
        default = null;
        example = "admin";
        description = ''
          Username for login.

          ::: {.warning}
            This option takes precedence over {option}`services.stash.settings.username`
          ::

        '';
      };

      passwordFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/path/to/password/file";
        description = ''
          Path to file containing password for login.

          ::: {.warning}
            This option takes precedence over {option}`services.stash.settings.password`
          ::

        '';
      };

      jwtSecretKeyFile = mkOption {
        type = types.path;
        description = "Path to file containing a secret used to sign JWT tokens.";
      };
      sessionStoreKeyFile = mkOption {
        type = types.path;
        description = "Path to file containing a secret for session store.";
      };

      mutableSettings = mkOption {
        description = ''
          Whether the Stash config.yml is writeable by Stash.

          If `false`, Any config changes done from within Stash UI will be temporary and reset to those defined in {option}`services.stash.settings` upon `Stash.service` restart.
          If `true`, the {option}`services.stash.settings` will only be used to initialize the Stash configuration if it does not exist, and are subsequently ignored.
        '';
        type = types.bool;
        default = true;
      };
      mutablePlugins = mkEnableOption "Whether plugins/themes can be installed, updated, uninstalled manually.";
      mutableScrapers = mkEnableOption "Whether scrapers can be installed, updated, uninstalled manually.";
      plugins = pluginType "plugins";
      scrapers = pluginType "scrapers";

      settings = mkOption {
        type = settingsType;
        description = "Stash configuration";
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion =
          !lib.xor (cfg.username != null || cfg.settings.username or null != null) (
            cfg.passwordFile != null || cfg.settings.password or null != null
          );
        message = "You must set either both username and password, or neither.";
      }
    ];

    services.stash.settings = {
      username = mkIf (cfg.username != null) cfg.username;
      plugins_path = mkIf (!cfg.mutablePlugins) cfg.plugins;
      scrapers_path = mkIf (!cfg.mutableScrapers) cfg.scrapers;
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.settings.port ];

    users.users.${cfg.user} = {
      inherit (cfg) group;
      isSystemUser = true;
      home = cfg.dataDir;
    };
    users.groups.${cfg.group} = { };

    systemd = {
      tmpfiles.settings."10-stash-datadir".${cfg.dataDir}."d" = {
        inherit (cfg) user group;
        mode = "0755";
      };
      services.stash = {
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        path = with pkgs; [
          ffmpeg-full
          python3
          ruby
        ];
        environment.STASH_CONFIG_FILE = "${cfg.dataDir}/config.yml";
        serviceConfig = {
          DynamicUser = false;
          User = cfg.user;
          Group = cfg.group;
          Restart = "on-failure";
          WorkingDirectory = cfg.dataDir;
          StateDirectory = mkIf (cfg.dataDir == "/var/lib/stash") (baseNameOf cfg.dataDir);
          ExecStartPre = pkgs.writers.writeBash "stash-setup.bash" (
            ''
              install -d ${cfg.settings.generated}
              if [[ -z "${toString cfg.mutableSettings}" || ! -f ${cfg.dataDir}/config.yml ]]; then
                env \
                  password=$(< ${cfg.passwordFile}) \
                  jwtSecretKeyFile=$(< ${cfg.jwtSecretKeyFile}) \
                  sessionStoreKeyFile=$(< ${cfg.sessionStoreKeyFile}) \
                  ${lib.getExe pkgs.yq-go} '
                    .jwt_secret_key = strenv(jwtSecretKeyFile) |
                    .session_store_key = strenv(sessionStoreKeyFile) |
                    (
                      strenv(password) as $password |
                      with(select($password != ""); .password = $password)
                    )
                  ' ${settingsFile} > ${cfg.dataDir}/config.yml
              fi
            ''
            + optionalString cfg.mutablePlugins ''
              install -d ${cfg.settings.plugins_path}
              ls ${cfg.plugins} | xargs -I{} ln -sf '${cfg.plugins}/{}' ${cfg.settings.plugins_path}
            ''
            + optionalString cfg.mutableScrapers ''
              install -d ${cfg.settings.scrapers_path}
              ls ${cfg.scrapers} | xargs -I{} ln -sf '${cfg.scrapers}/{}' ${cfg.settings.scrapers_path}
            ''
          );
          ExecStart = getExe cfg.package;

          ProtectHome = "tmpfs";
          BindReadOnlyPaths = mkIf (cfg.settings != { }) (map (stash: "${stash.path}") cfg.settings.stash);

          # hardening

          DevicePolicy = "auto"; # needed for hardware acceleration
          PrivateDevices = false; # needed for hardware acceleration
          AmbientCapabilities = [ "" ];
          CapabilityBoundingSet = [ "" ];
          ProtectSystem = "full";
          LockPersonality = true;
          NoNewPrivileges = true;
          PrivateTmp = true;
          PrivateUsers = true;
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProcSubset = "pid";
          ProtectProc = "invisible";
          RemoveIPC = true;
          RestrictAddressFamilies = [
            "AF_UNIX"
            "AF_INET"
            "AF_INET6"
          ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          MemoryDenyWriteExecute = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = [
            "~@cpu-emulation"
            "~@debug"
            "~@mount"
            "~@obsolete"
            "~@privileged"
          ];
        };
      };
    };
  };
}
