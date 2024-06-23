{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (pkgs)
    ffmpeg-full
    formats
    python3
    ruby
    runCommand
    writers
    yq-go
    ;

  inherit (lib)
    getExe
    literalExpression
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    optionalString
    toUpper
    ;

  inherit (lib.types)
    attrs
    bool
    either
    functionTo
    listOf
    package
    port
    str
    submodule
    ;

  cfg = config.services.stash;

  dataDir = "/var/lib/stash";

  settingsFormat = formats.yaml { };
  settingsFile = settingsFormat.generate "config.yml" cfg.settings;
  settingsType = submodule {
    freeformType = settingsFormat.type;

    options = {
      host = mkOption {
        type = str;
        default = "0.0.0.0";
        example = "::1";
        description = "The ip address that Stash should bind to.";
      };

      port = mkOption {
        type = port;
        default = 9999;
        example = 1234;
        description = "The port that Stash should listen on.";
      };

      jwt_secret_key = mkOption {
        type = str;
        description = ''
          64 bytes long string.
          Can be generated using {command}`openssl rand -hex 32`.'';
      };
      session_store_key = mkOption {
        type = str;
        description = ''
          64 bytes long string.
          Can be generated using {command}`openssl rand -hex 32`.'';
      };

      stash = mkOption {
        type = listOf stashType;
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
        type = listOf stashBoxType;
        description = ''Stash-box facilitates automated tagging of scenes and performers based on fingerprints and filenames'';
        example = literalExpression ''
          {
            stash_boxes = [
              {
                name = "StashDB";
                endpoint = "https://stashdb.org/graphql";
                apikey = "secret";
              }
            ];
          }
        '';
      };
      ui.frontPageContent = mkOption {
        description = "Search filters to display on the front page.";
        type = either (listOf attrs) (functionTo (listOf attrs));
        default = [
          uiPresets.recentlyReleasedScenes
          uiPresets.recentlyAddedStudios
          uiPresets.recentlyReleasedMovies
          uiPresets.recentlyAddedPerformers
          uiPresets.recentlyReleasedGalleries
        ];
        defaultText = literalExpression ''
          presets: [
            presets.recentlyReleasedScenes
            presets.recentlyAddedStudios
            presets.recentlyReleasedMovies
            presets.recentlyAddedPerformers
            presets.recentlyReleasedGalleries
          ]
        '';
        example = literalExpression ''
          presets: [
            # You can find your desired saved filter id using the graphql api.
            # e.g. `curl -X POST -H "Content-Type: application/json" --data '{ "query": "{ findSavedFilters(mode: SCENE_MARKERS) { id name } }" }' localhost:9999/graphql`
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
            presets.recentlyAddedScenes
            presets.recentlyAddedGalleries
            presets.recentlyAddedImages
            presets.recentlyAddedMovies
          ]
        '';
        apply = type: if builtins.isFunction type then (type uiPresets) else type;
      };
    };
  };
  settingsDefault = {
    blobs_path = "${dataDir}/blobs";
    cache = "${dataDir}/cache";
    database = "${dataDir}/stash-go.sqlite";
    generated = "${dataDir}/generated";
    plugins_path = if (cfg.mutablePlugins) then "${dataDir}/plugins" else cfg.plugins;
    scrapers_path = if (cfg.mutableScrapers) then "${dataDir}/scrapers" else cfg.scrapers;

    blobs_storage = "FILESYSTEM";
    calculate_md5 = false;
    create_image_clip_from_videos = false;
    dangerous_allow_public_without_auth = false;
    gallery_cover_regex = "(poster|cover|folder|board)\.[^\.]+$";
    no_proxy = "localhost,127.0.0.1,192.168.0.0/16,10.0.0.0/8,172.16.0.0/12";
    nobrowser = true;
    notifications_enabled = true;
    parallel_tasks = 1;
    preview_audio = true;
    preview_exclude_end = 0;
    preview_exclude_start = 0;
    preview_segment_duration = 0.75;
    preview_segments = 12;
    security_tripwire_accessed_from_public_internet = "";
    sequential_scanning = false;
    show_one_time_moved_notification = true;
    sound_on_preview = false;
    theme_color = "#202b33";
    video_file_naming_algorithm = "OSHASH";
    write_image_thumbnails = true;
  };

  stashType = submodule {
    options = {
      path = mkOption {
        type = str;
        description = "location of your media files";
      };
      excludevideo = mkOption {
        type = bool;
        default = false;
        description = "Whether to exclude video files from being scanned into Stash";
      };
      excludeimage = mkOption {
        type = bool;
        default = false;
        description = "Whether to exclude image files from being scanned into Stash";
      };
    };
  };
  stashBoxType = submodule {
    options = {
      name = mkOption {
        type = str;
        description = "The name of the Stash Box";
      };
      endpoint = mkOption {
        type = str;
        description = "URL to the Stash Box graphql api";
      };
      apikey = mkOption {
        type = str;
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

  pluginType = (
    kind:
    mkOption {
      type = listOf package;
      default = [ ];
      description = ''
        The ${kind} Stash should be started with.
      '';
      apply = (
        srcs:
        optionalString (srcs != [ ]) (
          runCommand "stash-${kind}"
            {
              inherit srcs;
              buildInputs = [ yq-go ];
              preferLocalBuild = true;
            }
            ''
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
            ''
        )
      );
    }
  );
in
{
  meta.maintainers = with lib; [ DrakeTDL ];
  options = {
    services.stash = {
      enable = mkEnableOption "stash";

      package = mkPackageOption pkgs "stash" { };

      user = mkOption {
        type = str;
        default = "stash";
        description = "User account under which stash runs.";
      };

      group = mkOption {
        type = str;
        default = "stash";
        description = "Group under which stash runs.";
      };

      openFirewall = mkOption {
        type = bool;
        default = false;
        description = "Open ports in the firewall for the stash web interface.";
      };

      mutableSettings = mkOption {
        description = ''
          Whether the Stash config.yml is writeable by Stash.

          If `false`, Any config changes done from within Stash UI will be temporary and reset to those defined in {option}`services.stash.settings` upon `Stash.service` restart.
          If `true`, the {option}`services.stash.settings` will only be used to initialize the Stash configuration if it does not exist, and are subsequently ignored.
        '';
        type = bool;
        default = true;
      };
      mutablePlugins = mkEnableOption "Whether plugins/themes can be installed, updated, uninstalled manually.";
      mutableScrapers = mkEnableOption "Whether scrapers can be installed, updated, uninstalled manually.";
      plugins = pluginType "plugins";
      scrapers = pluginType "scrapers";

      settings = mkOption {
        type = settingsType;
        description = ''Stash configuration'';
        defaultText = literalExpression ''
          {
            blobs_path = "${dataDir}/blobs";
            cache = "${dataDir}/cache";
            database = "${dataDir}/stash-go.sqlite";
            generated = "${dataDir}/generated";
            plugins_path = if (cfg.mutablePlugins) then "${dataDir}/plugins" else cfg.plugins;
            scrapers_path = if (cfg.mutableScrapers) then "${dataDir}/scrapers" else cfg.scrapers;

            blobs_storage = "FILESYSTEM";
            calculate_md5 = false;
            create_image_clip_from_videos = false;
            dangerous_allow_public_without_auth = false;
            gallery_cover_regex = "(poster|cover|folder|board)\.[^\.]+$";
            no_proxy = "localhost,127.0.0.1,192.168.0.0/16,10.0.0.0/8,172.16.0.0/12";
            nobrowser = true;
            notifications_enabled = true;
            parallel_tasks = 1;
            preview_audio = true;
            preview_exclude_end = 0;
            preview_exclude_start = 0;
            preview_segment_duration = 0.75;
            preview_segments = 12;
            security_tripwire_accessed_from_public_internet = "";
            sequential_scanning = false;
            show_one_time_moved_notification = true;
            sound_on_preview = false;
            theme_color = "#202b33";
            video_file_naming_algorithm = "OSHASH";
            write_image_thumbnails = true;
          }
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion =
          (cfg.settings.username or null != null -> cfg.settings.password or null != null)
          && (cfg.settings.password or null != null -> cfg.settings.username or null != null);
        message = "You must set either both username and password, or neither.";
      }
    ];

    services.stash.settings = settingsDefault;

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.settings.port ];

    systemd.services.stash = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      path = [
        ffmpeg-full
        python3
        ruby
      ];
      environment.STASH_CONFIG_FILE = "${dataDir}/config.yml";
      serviceConfig = {
        DynamicUser = true;
        User = cfg.user;
        Group = cfg.group;
        Restart = "on-failure";
        WorkingDirectory = dataDir;
        StateDirectory = baseNameOf dataDir;
        ExecStartPre = writers.writeBash "stash-setup.bash" (
          ''
            install -d ${cfg.settings.generated}
            if [[ ! -z "${toString cfg.mutableSettings}" || ! -f ${dataDir}/config.yml ]]; then
              install -T ${settingsFile} ${dataDir}/config.yml
            fi
          ''
          + optionalString (cfg.mutablePlugins) ''
            install -d ${cfg.settings.plugins_path}
            ls ${cfg.plugins} | xargs -I{} ln -sf '${cfg.plugins}/{}' ${cfg.settings.plugins_path}
          ''
          + optionalString (cfg.mutableScrapers) ''
            install -d ${cfg.settings.scrapers_path}
            ls ${cfg.scrapers} | xargs -I{} ln -sf '${cfg.scrapers}/{}' ${cfg.settings.scrapers_path}
          ''
        );
        ExecStart = getExe cfg.package;

        ProtectHome = "tmpfs";
        BindReadOnlyPaths = mkIf (cfg.settings != { }) (map (stash: "-${stash.path}") cfg.settings.stash);

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
}
