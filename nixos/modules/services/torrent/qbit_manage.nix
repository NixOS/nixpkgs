{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.qbit_manage;
  yaml = pkgs.formats.yaml { };
  createYAMLConfig =
    config:
    pkgs.runCommand "config.yml" { } ''
      # Need to run sed to remove the quotes around !ENV values
      # otherwise qbit_manage will not interpret them as environment variables
      sed -E "s/'(!ENV) (.*)'/\1 \2/g" '${yaml.generate "tmp" config}' > $out
    '';
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    mkPackageOption
    match
    stringLength
    strings
    optionals
    ;
  inherit (lib.types)
    str
    path
    bool
    int
    float
    listOf
    attrsOf
    submodule
    nullOr
    either
    enum
    port
    addCheck
    ;
in
{
  options.services.qbit_manage = {
    enable = mkEnableOption "Enable qbit_manage";

    package = mkPackageOption pkgs "qbit_manage" { };

    user = mkOption {
      type = str;
      default = "qbit_manage";
      description = "User account under which qbit_manage runs.";
    };

    group = mkOption {
      type = str;
      default = "qbit_manage";
      description = "Group under which qbit_manage runs.";
    };

    dataDir = mkOption {
      type = path;
      default = "/var/lib/qbit_manage";
      description = "Directory to store qbit_manage data files.";
    };

    environmentFile = mkOption {
      type = nullOr path;
      default = null;
      description = "Path to an environment file to load environment variables from.";
    };

    openFirewall = mkOption {
      type = bool;
      default = false;
      description = "Open firewall for webUI.";
    };

    config = mkOption {
      description = ''
        qbit_manage configuration. Will be translated into YAML.
        For environment variable support, use '!ENV VAR_NAME' as the value.
        See https://github.com/StuffAnThings/qbit_manage/wiki/Config-Setup for more information.

        Leave unset to configure without nix.
      '';
      default = null;
      type = nullOr (submodule {
        freeformType = yaml.type;
        options = {
          qbt = mkOption {
            description = "This section defines your qBittorrent instance";
            type = submodule {
              options = {
                host = mkOption {
                  type = str;
                  default = "localhost:8080";
                  description = "IP address of your qBittorrent installation.";
                };

                user = mkOption {
                  type = nullOr str;
                  description = "The user name of your qBittorrent webUI.";
                };

                pass = mkOption {
                  type = nullOr (addCheck str (p: strings.hasPrefix "!ENV " p));
                  description = "The password of your qBbittorrent webUI.";
                };
              };
            };
          };
          settings = mkOption {
            description = "This section defines any settings defined in the configuration.";
            type = submodule {
              options = {
                force_auto_tmm = mkOption {
                  type = bool;
                  default = false;
                  description = "Will force qBittorrent to enable Automatic Torrent Management for each torrent.";
                };

                force_auto_tmm_ignore_tags = mkOption {
                  type = listOf str;
                  default = [ ];
                  description = "Torrents with these tags will be ignored when force_auto_tmm is enabled.";
                };

                tracker_error_tag = mkOption {
                  type = str;
                  default = "issue";
                  description = "Define the tag of any torrents that do not have a working tracker. ";
                };

                nohardlinks_tag = mkOption {
                  type = str;
                  default = "noHL";
                  description = "Define the tag of any torrents that don't have hardlinks.";
                };

                private_tag = mkOption {
                  type = nullOr str;
                  default = null;
                  description = "Define the tag of any torrents that are private.";
                };

                share_limits_tag = mkOption {
                  type = str;
                  default = "~share_limit";
                  description = "Will add this tag when applying share limits to provide an easy way to filter torrents by share limit group/priority for each torrent.";
                };

                share_limits_min_seeding_time_tag = mkOption {
                  type = str;
                  default = "MinSeedTimeNotReached";
                  description = "Will add this tag when applying share limits to torrents that have not yet reached the minimum seeding time.";
                };

                share_limits_min_num_seeds_tag = mkOption {
                  type = str;
                  default = "MinSeedsNotMet";
                  description = "Will add this tag when applying share limits to torrents that have not yet reached the minimum number of seeds.";
                };

                share_limits_last_active_tag = mkOption {
                  type = str;
                  default = "LastActiveLimitNotReached";
                  description = "Will add this tag when applying share limits to torrents that have not yet reached the last active limit.";
                };

                cat_filter_completed = mkOption {
                  type = bool;
                  default = true;
                  description = "When running --cat-update function, it will filter for completed torrents only.";
                };

                share_limits_filter_completed = mkOption {
                  type = bool;
                  default = true;
                  description = "When running --share-limits function, it will filter for completed torrents only.";
                };

                tag_nohardlinks_filter_completed = mkOption {
                  type = bool;
                  default = true;
                  description = "When running --tag-nohardlinks function, it will filter for completed torrents only.";
                };

                cat_update_all = mkOption {
                  type = bool;
                  default = true;
                  description = "When running --cat-update function, it will check and update all torrents categories, otherwise it will only update uncategorized torrents.";
                };

                disable_qbt_default_share_limits = mkOption {
                  type = bool;
                  default = true;
                  description = "When running --share-limits function, it allows QBM to handle share limits by disabling qBittorrents default Share limits.";
                };

                tag_stalled_torrents = mkOption {
                  type = bool;
                  default = true;
                  description = "Tags any downloading torrents that are stalled with the user defined stalledDL tag when running the tag_update command.";
                };

                rem_unregistered_ignore_list = mkOption {
                  type = listOf str;
                  default = [ ];
                  description = "Ignores a list of words found in the status of the tracker when running rem_unregistered command and will not remove the torrent if matched.";
                };

                rem_unregistered_grace_minutes = mkOption {
                  type = int;
                  default = 10;
                  description = "Minimum age in minutes to protect newly added torrents from removal when a tracker reports unregistered. Set to 0 to disable.";
                };

                rem_unregistered_max_torrents = mkOption {
                  type = int;
                  default = 10;
                  description = "Maximum number of torrents to remove per tracker per run. Set to 0 to disable.";
                };

                stalled_tag = mkOption {
                  type = str;
                  default = "stalledDL";
                  description = "Define the tag of any downloading torrents that are stalled.";
                };

                rem_unregistered_filter_completed = mkOption {
                  type = bool;
                  default = false;
                  description = "When running --rem-unregistered function, it will only check uncompleted torrents.";
                };
              };
            };
          };

          directory = mkOption {
            description = "This section defines the directories that qbit_manage will be looking into for various parts of the script.";
            type = submodule {
              options = {
                root_dir = mkOption {
                  type = nullOr path;
                  default = null;
                  description = ''
                    Root downloads directory used to check for orphaned files, noHL, and remove unregistered.
                    This directory is where you place all your downloads.
                    This will need to be how qB views the directory where it places the downloads.
                    This is required if you're using qbit_manage and/or qBittorrent within a container.
                  '';
                };

                remote_dir = mkOption {
                  type = nullOr path;
                  default = null;
                  description = ''
                    Path of docker host mapping of root_dir, this must be set if you're running qbit_manage locally (not required if running qbit_manage in a container) and qBittorrent/cross_seed is in a docker.
                    Essentially this is where your downloads are being kept on the host.
                  '';
                };

                recycle_bin = mkOption {
                  type = nullOr path;
                  default = null;
                  description = ''
                    Path of the RecycleBin folder.
                    Default location is set to remote_dir/.RecycleBin.
                    All files in this folder will be cleaned up based on your recycle bin settings.
                  '';
                };

                torrents_dir = mkOption {
                  type = nullOr path;
                  default = null;
                  description = ''
                    Path of the your qbittorrent torrents directory.
                    Required for save_torrents attribute in recyclebin /qbittorrent/data/BT_backup.
                  '';
                };

                orphaned_dir = mkOption {
                  type = path;
                  description = ''
                    Path of the Orphaned Directory folder.
                    Default location is set to remote_dir/orphaned_data.
                    All files in this folder will be cleaned up based on your orphaned data settings.
                    Only orphaned data shall exist in this path as all contents are considered disposable.
                  '';
                };
              };
            };
          };

          cat = mkOption {
            description = "This section defines the categories that you are currently using and the save path's that are associated with them.";
            type = nullOr (attrsOf path);
            default = null;
          };

          cat_change = mkOption {
            description = "This moves all the torrents from one category to another category if the torrents are marked as complete.";
            type = nullOr (attrsOf str);
            default = null;
          };

          tracker = mkOption {
            description = "This section defines the tags used based upon the tracker's URL.";
            default = null;
            type = nullOr (
              attrsOf (submodule {
                options = {
                  tag = mkOption {
                    type = either str (listOf str);
                    description = "The tracker tag or additional list of tags defined.";
                  };

                  cat = mkOption {
                    type = nullOr str;
                    default = null;
                    description = ''
                      Set the category based on tracker URL.
                      This category option takes priority over the category defined in cat.
                    '';
                  };

                  notifiarr = mkOption {
                    type = nullOr str;
                    default = null;
                    description = ''
                      Set this to the notifiarr react name.
                      This is used to add indexer reactions to the notifications sent by Notifiarr.
                    '';
                  };
                };
              })
            );
          };

          nohardlinks = mkOption {
            description = ''
              This functionality will tag any torrent's whose file (or largest file if multi-file) does not have any hardlinks outside the qbm root_dir.
              Note that ignore_root_dir (Default: True) will ignore any hardlinks detected in the same root_dir.
            '';
            default = null;
            type = nullOr (
              either (listOf str) (
                attrsOf (submodule {
                  options = {
                    exclude_tags = mkOption {
                      type = nullOr listOf str;
                      default = null;
                      description = ''
                        List of tags to exclude from the check.
                        Torrents with any of these tags will not be processed.
                        This is useful to exclude certain trackers from being scanned for hardlinking purposes.
                      '';
                    };

                    ignore_root_dir = mkOption {
                      type = bool;
                      default = true;
                      description = "Ignore any hardlinks detected in the same root_dir.";
                    };
                  };
                })
              )
            );
          };

          share_limits = mkOption {
            description = ''
              Control how torrent share limits are set depending on the priority of your grouping.
              This can apply a max ratio, seed time limits to your torrents or limit your torrent upload speed as well.
              Each torrent will be matched with the share limit group with the highest priority that meets the group filter criteria.
              Each torrent can only be matched with one share limit group.
            '';
            default = null;
            type = nullOr (
              attrsOf (submodule {
                options = {
                  priority = mkOption {
                    type = int;
                    description = ''
                      This is the priority of your grouping.
                      The lower the number the higher the priority.
                      This determines the order in which share limits are applied based on the filters set in this group.
                    '';
                    default = null;
                  };

                  include_all_tags = mkOption {
                    type = nullOr (listOf str);
                    default = null;
                    description = ''
                      Filter the group based on one or more tags.
                      Multiple include_all_tags are checked with an AND condition.
                      All tags defined here must be present in the torrent for it to be included in this group.
                    '';
                  };

                  include_any_tags = mkOption {
                    type = nullOr (listOf str);
                    default = null;
                    description = ''
                      Filter the group based on one or more tags.
                      Multiple include_any_tags are checked with an OR condition.
                      Any tags defined here must be present in the torrent for it to be included in this group.
                    '';
                  };

                  exclude_all_tags = mkOption {
                    type = nullOr (listOf str);
                    default = null;
                    description = ''
                      Filter the group based on one or more tags.
                      Multiple exclude_all_tags are checked with an AND condition.
                      All tags defined here must be present in the torrent for it to be excluded in this group.
                    '';
                  };

                  exclude_any_tags = mkOption {
                    type = nullOr (listOf str);
                    default = null;
                    description = ''
                      Filter the group based on one or more tags.
                      Multiple exclude_any_tags are checked with an OR condition.
                      Any tags defined here must be present in the torrent for it to be excluded in this group.
                    '';
                  };

                  categories = mkOption {
                    type = nullOr (listOf str);
                    default = null;
                    description = ''
                      Filter by including one or more categories.
                      Multiple categories are checked with an OR condition.
                      Since one torrent can only be associated with a single category, multiple categories are checked with an OR condition.
                    '';
                  };

                  min_torrent_size = mkOption {
                    type = nullOr (
                      addCheck str (size: match "^[0-9]+(\\.[0-9]+)?(KB|MB|GB|TB|PB|KiB|MiB|GiB|TiB|PiB)$" size != null)
                    );
                    default = null;
                    description = ''
                      Only include torrents at least this size in the group.
                      Accepts human‑readable sizes like 200MB, 40GB, 1024MiB.
                      Leave unset/blank to disable.
                    '';
                  };

                  max_torrent_size = mkOption {
                    type = nullOr (
                      addCheck str (size: match "^[0-9]+(\\.[0-9]+)?(KB|MB|GB|TB|PB|KiB|MiB|GiB|TiB|PiB)$" size != null)
                    );
                    default = null;
                    description = ''
                      Only include torrents no larger than this size in the group.
                      Accepts human‑readable sizes like 200MB, 40GB, 1024MiB.
                      Leave unset/blank to disable.
                    '';
                  };

                  cleanup = mkOption {
                    type = bool;
                    default = false;
                    description = ''
                      WARNING!! Setting this as true will remove and delete contents of any torrents that satisfies the share limits (max time OR max ratio).
                      It will also delete the torrent's data if and only if no other torrents are using the same folder/files.
                    '';
                  };

                  max_ratio = mkOption {
                    type = float;
                    default = -1.0;
                    description = ''
                      Will set the torrent Maximum share ratio until torrent is stopped from seeding/uploading and may be cleaned up / removed if the minimums have been met.
                      (-2 : Global Limit , -1 : No Limit).
                    '';
                  };

                  max_seeding_time = mkOption {
                    type = str;
                    default = "-1";
                    description = ''
                      Will delete the torrent if cleanup variable is set and if torrent has been inactive longer than x minutes.
                      See Some examples of valid time expressions 32m, 2h32m, 3d2h32m, 1w3d2h32m.
                      (-1 : Disable).
                    '';
                  };

                  min_seeding_time = mkOption {
                    type = str;
                    default = "0";
                    description = ''
                      Will prevent torrent deletion by the cleanup variable if the torrent has reached the max_ratio limit you have set.
                      If the torrent has not yet reached this minimum seeding time, it will change the share limits back to no limits and resume the torrent to continue seeding.
                      See Some examples of valid time expressions 32m, 2h32m, 3d2h32m, 1w3d2h32m.
                      MANDATORY: Must use also max_ratio with a value greater than 0 (default: -1) for this to work.
                      If you use both min_seed_time and max_seed_time, then you must set the value of max_seed_time to a number greater than min_seed_time.
                    '';
                  };

                  min_last_active = mkOption {
                    type = str;
                    default = "0";
                    description = ''
                      Will prevent torrent deletion by cleanup variable if torrent has been active within the last x minutes.
                      If the torrent has been active within the last x minutes, it will change the share limits back to no limits and resume the torrent to continue seeding.
                      See Some examples of valid time expressions 32m, 2h32m, 3d2h32m, 1w3d2h32m.
                    '';
                  };

                  limit_upload_speed = mkOption {
                    type = int;
                    default = -1;
                    description = "Will limit the upload speed KiB/s (KiloBytes/second) (-1 : No Limit).";
                  };

                  upload_speed_on_limit_reached = mkOption {
                    type = int;
                    default = -1;
                    description = ''
                      When cleanup is false and a torrent reaches its share limits, throttle per‑torrent upload to this value (KiB/s).
                      Use -1 for unlimited.
                      QBM will also clear the share limits to prevent qBittorrent from pausing, allowing continued seeding at the throttled rate.
                    '';
                  };

                  enable_group_upload_speed = mkOption {
                    type = bool;
                    default = false;
                    description = ''
                      Upload speed limits are applied at the group level.
                      This will take limit_upload_speed defined and divide it equally among the number of torrents in the group.
                    '';
                  };

                  reset_upload_speed_on_unmet_minimums = mkOption {
                    type = bool;
                    default = true;
                    description = ''
                      Controls whether upload speed limits are reset when minimum conditions are not met.
                      When true (default), upload speed limits will be reset to unlimited if minimum seeding time, number of seeds, or last active time conditions are not satisfied.
                      When false, existing upload speed limits will be preserved for bandwidth management purposes.
                    '';
                  };

                  resume_torrent_after_change = mkOption {
                    type = bool;
                    default = true;
                    description = "Will resume your torrent after changing share limits.";
                  };

                  add_group_to_tag = mkOption {
                    type = bool;
                    default = true;
                    description = ''
                      This adds your grouping as a tag with a prefix defined in settings (share_limits_tag).
                      Example: A grouping named noHL with a priority of 1 will have a tag set to ~share_limit_1.noHL (if using the default prefix).
                    '';
                  };

                  min_num_seeds = mkOption {
                    type = int;
                    default = 0;
                    description = ''
                      Will prevent torrent deletion by cleanup variable if the number of seeds is less than the value set here (depending on the tracker, you may or may not be included).
                      If the torrent has less number of seeds than the min_num_seeds, the share limits will be changed back to no limits and resume the torrent to continue seeding.
                    '';
                  };

                  custom_tag = mkOption {
                    type = nullOr str;
                    default = null;
                    description = ''
                      Apply a custom tag name for this particular group.
                      WARNING (This tag MUST be unique as it will be used to determine share limits.
                      Please ensure it does not overlap with any other tags in qBittorrent).
                    '';
                  };
                };
              })
            );
          };

          recyclebin = mkOption {
            description = "Recycle Bin method of deletion will move files into the recycle bin (Located in /root_dir/.RecycleBin) instead of directly deleting them in qbit.";
            type = submodule {
              options = {
                enabled = mkOption {
                  type = bool;
                  default = true;
                  description = "Enable recycle bin functionality.";
                };

                empty_after_x_days = mkOption {
                  type = nullOr int;
                  default = null;
                  description = ''
                    Will delete Recycle Bin contents if the files have been in the Recycle Bin for more than x days.
                    (Uses date modified to track the time).
                  '';
                };

                save_torrents = mkOption {
                  type = bool;
                  default = false;
                  description = ''
                    This will save a copy of your .torrent and .fastresume file in the recycle bin before deleting it from qbittorrent.
                    This requires the torrents_dir to be defined.
                  '';
                };

                split_by_category = mkOption {
                  type = bool;
                  default = false;
                  description = "This will split the recycle bin folder by the save path defined in the cat attribute and add the base folder name of the recycle bin that was defined in recycle_bin.";
                };
              };
            };
          };

          orphaned = mkOption {
            description = "This section allows for the exclusion of certain files from being considered Orphaned";
            type = submodule {
              options = {
                empty_after_x_days = mkOption {
                  type = nullOr int;
                  default = null;
                  description = ''
                    Will delete Orphaned data contents if the files have been in the Orphaned data for more than x days.
                    (Uses date modified to track the time).
                  '';
                };

                exclude_patterns = mkOption {
                  type = nullOr (listOf str);
                  default = null;
                  description = "List of patterns to exclude certain files from orphaned.";
                };

                max_orphaned_files_to_delete = mkOption {
                  type = int;
                  default = 50;
                  description = ''
                    This will help reduce the number of accidental large amount orphaned deletions in a single run.
                    Set your desired threshold for the maximum number of orphaned files qbm will delete in a single run.
                    (-1 to disable safeguards).
                  '';
                };

                min_file_age_minutes = mkOption {
                  type = int;
                  default = 0;
                  description = ''
                    Minimum age in minutes for files to be considered orphaned.
                    Files newer than this will be protected from deletion to prevent removal of actively uploading files.
                    Set to 0 to disable age protection.
                  '';
                };
              };
            };
          };

          apprise = mkOption {
            description = "Apprise integration is used in conjunction with webhooks to allow notifications via apprise-api.";
            default = null;
            type = nullOr (submodule {
              options = {
                api_url = mkOption {
                  type = str;
                  description = "Apprise API Endpoint URL.";
                };

                notify_url = mkOption {
                  type = str;
                  description = "Notification Services URL.";
                };
              };
            });
          };

          notifiarr = mkOption {
            description = "Notifiarr integration is used in conjunction with webhooks to allow discord notifications via Notifiarr.";
            default = null;
            type = nullOr (submodule {
              options = {
                apikey = mkOption {
                  type = str;
                  description = "Notifiarr API key.";
                };

                instance = mkOption {
                  type = nullOr str;
                  default = null;
                  description = ''
                    Optional unique value used to identify your instance.
                    (could be your username on notifiarr for example).
                  '';
                };
              };
            });
          };

          webhooks = mkOption {
            description = "Provide webhook notifications based on event triggers.";
            type = nullOr (submodule {
              options =
                let
                  type = nullOr (enum [
                    "apprise"
                    "notifiarr"
                  ]);
                in
                {
                  error = mkOption {
                    inherit type;
                    default = null;
                    description = "When errors occur during the run.";
                  };

                  run_start = mkOption {
                    inherit type;
                    default = null;
                    description = "At the beginning of every run.";
                  };

                  run_end = mkOption {
                    inherit type;
                    default = null;
                    description = "At the end of every run.";
                  };

                  function = mkOption {
                    description = "Function specific notifications.";
                    type = submodule {
                      options = {
                        recheck = mkOption {
                          inherit type;
                          default = null;
                          description = "During the recheck function.";
                        };

                        cat_update = mkOption {
                          inherit type;
                          default = null;
                          description = "During the category update function.";
                        };

                        tag_update = mkOption {
                          inherit type;
                          default = null;
                          description = "During the tag update function.";
                        };

                        rem_unregistered = mkOption {
                          inherit type;
                          default = null;
                          description = "During the removing unregistered torrents function.";
                        };

                        tag_tracker_error = mkOption {
                          inherit type;
                          default = null;
                          description = "During the removing unregistered torrents/tag tracker error function.";
                        };

                        rem_orphaned = mkOption {
                          inherit type;
                          default = null;
                          description = "During the removing orphaned function.";
                        };

                        tag_nohardlinks = mkOption {
                          inherit type;
                          default = null;
                          description = "During the tag no hardlinks function.";
                        };

                        share_limits = mkOption {
                          inherit type;
                          default = null;
                          description = "During the share limits function.";
                        };

                        cleanup_dirs = mkOption {
                          inherit type;
                          default = null;
                          description = "When files are deleted from certain directories.";
                        };
                      };
                    };
                  };
                };
            });
          };
        };
      });
    };

    commands = mkOption {
      description = ''
        The commands that you want qbm to execute.
        See https://github.com/StuffAnThings/qbit_manage/wiki/Commands for more information.
      '';
      type = submodule {
        options = {
          webServer = mkOption {
            type = bool;
            default = false;
            description = "Start the webUI server to handle command requests via HTTP API.";
          };

          host = mkOption {
            type = nullOr str;
            default = null;
            description = "Hostname for the web server.";
          };

          port = mkOption {
            type = port;
            default = 8080;
            description = "Port number for the web server.";
          };

          baseURL = mkOption {
            type = nullOr str;
            default = null;
            description = "Base URL path for the web UI (e.g., '/qbit_manage').";
          };

          run = mkOption {
            type = bool;
            default = false;
            description = "Run without the scheduler. Script will exit after completion.";
          };

          schedule = mkOption {
            type = int;
            default = 1440;
            description = "Schedule to run every x minutes.";
          };

          startupDelay = mkOption {
            type = int;
            default = 0;
            description = "Set delay in seconds on the first run of a schedule";
          };

          logFile = mkOption {
            type = nullOr str;
            default = null;
            description = "This is used if you want to use a different name for your log file.";
          };

          recheck = mkOption {
            type = bool;
            default = false;
            description = "Recheck paused torrents sorted by lowest size. Resume if Completed.";
          };

          catUpdate = mkOption {
            type = bool;
            default = false;
            description = "Use this option to update your categories or switch between them.";
          };

          tagUpdate = mkOption {
            type = bool;
            default = false;
            description = "Use this if you would like to update your tags and/or set seed goals/limit upload speed by tag.";
          };

          remUnregistered = mkOption {
            type = bool;
            default = false;
            description = "Use this if you would like to remove unregistered torrents.";
          };

          tagTrackerError = mkOption {
            type = bool;
            default = false;
            description = "Use this if you would like to tag torrents that do not have a working tracker.";
          };

          remOrphaned = mkOption {
            type = bool;
            default = false;
            description = "Use this if you would like to remove orphaned files from your 'root_dir' directory that are not referenced by any torrents.";
          };

          tagNoHardLinks = mkOption {
            type = bool;
            default = false;
            description = "Use this to tag any torrents where the torrent's largest file does not have any hardlinks associated with any of the files outside of your Qbit_Manage root directory.";
          };

          shareLimits = mkOption {
            type = bool;
            default = false;
            description = "Control how torrent share limits are set depending on the priority of your grouping.";
          };

          skipCleanup = mkOption {
            type = bool;
            default = false;
            description = "Use this to skip emptying the recycle Bin folder and Orphaned directory.";
          };

          dryRun = mkOption {
            type = bool;
            default = false;
            description = "If you would like to see what is gonna happen but not actually move/delete or tag/categorize anything.";
          };

          logLevel = mkOption {
            type = enum [
              "DEBUG"
              "INFO"
              "WARNING"
              "ERROR"
              "CRITICAL"
            ];
            default = "INFO";
            description = "Change the output log level.";
          };

          logSize = mkOption {
            type = int;
            default = 10;
            description = "Maximum log size per file (in MB).";
          };

          logCount = mkOption {
            type = int;
            default = 5;
            description = "Maximum number of logs to keep.";
          };

          debug = mkOption {
            type = bool;
            default = false;
            description = "Adds debug logs.";
          };

          trace = mkOption {
            type = bool;
            default = false;
            description = "Adds trace logs.";
          };

          divider = mkOption {
            type = addCheck str (div: stringLength div == 1);
            default = "=";
            description = "Character that divide the sections.";
          };

          width = mkOption {
            type = int;
            default = 100;
            description = "Screen width.";
          };

          skipQbVersionCheck = mkOption {
            type = bool;
            default = false;
            description = "Bypass qBittorrent/libtorrent version compatibility check.";
          };
        };
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion =
          (cfg.config.directory.root_dir != null)
          || (cfg.config == null)
          || (
            (!cfg.commands.remOrphaned) && (!cfg.commands.tagNoHardLinks) && (!cfg.commands.remUnregistered)
          );
        message = "services.qbit_manage.config.directory.root_dir must be set when using remOrphaned, tagNoHardLinks or remUnregistered commands.";
      }
    ];

    networking.firewall.allowedTCPPorts = mkIf (cfg.openFirewall && cfg.commands.webServer) [
      cfg.commands.port
    ];

    users = {
      users = mkIf (cfg.user == "qbit_manage") {
        qbit_manage = {
          inherit (cfg) group;
          isSystemUser = true;
        };
      };

      groups = mkIf (cfg.group == "qbit_manage") { qbit_manage = { }; };
    };

    systemd = {
      tmpfiles.settings.qbit_manage = {
        "${cfg.dataDir}".d = {
          inherit (cfg) user group;
          mode = "755";
        };

        "${cfg.dataDir}/config.yml"."L+" = mkIf (cfg.config != null) {
          inherit (cfg) user group;
          mode = "1400";
          argument = toString (createYAMLConfig cfg.config);
        };
      };

      services."qbit_manage" = {
        description = "Tool to manage tasks for qbittorrent";
        enable = true;
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "simple";
          User = cfg.user;
          Group = cfg.group;
          ExecStart =
            let
              cmds = cfg.commands;

              logFlags = [
                "--log-level ${cmds.logLevel}"
                "--log-size ${toString cmds.logSize}"
                "--log-count ${toString cmds.logCount}"
                "--divider ${cmds.divider}"
                "--width ${toString cmds.width}"
              ]
              ++ optionals cmds.debug [
                "--debug"
              ]
              ++ optionals cmds.trace [
                "--trace"
              ]
              ++ optionals (cmds.logFile != null) [
                "--log-file ${cmds.logFile}"
              ];

              webServerFlags =
                if cmds.webServer then
                  [
                    "--web-server"
                    "--port ${toString cmds.port}"
                  ]
                  ++ optionals (cmds.host != null) [
                    "--host ${cmds.host}"
                  ]
                  ++ optionals (cmds.baseURL != null) [
                    "--base-url ${cmds.baseURL}"
                  ]
                else
                  [ "--web-server=False" ];

              commandFlags = [
                "--startup-delay ${toString cmds.startupDelay}"
              ]
              ++ optionals cmds.run [
                "--run"
              ]
              ++ optionals (!cmds.run) [
                "--schedule ${toString cmds.schedule}"
              ]
              ++ optionals cmds.recheck [
                "--recheck"
              ]
              ++ optionals cmds.catUpdate [
                "--cat-update"
              ]
              ++ optionals cmds.tagUpdate [
                "--tag-update"
              ]
              ++ optionals cmds.remUnregistered [
                "--rem-unregistered"
              ]
              ++ optionals cmds.tagTrackerError [
                "--tag-tracker-error"
              ]
              ++ optionals cmds.remOrphaned [
                "--rem-orphaned"
              ]
              ++ optionals cmds.tagNoHardLinks [
                "--tag-nohardlinks"
              ]
              ++ optionals cmds.shareLimits [
                "--share-limits"
              ]
              ++ optionals cmds.skipCleanup [
                "--skip-cleanup"
              ]
              ++ optionals cmds.dryRun [
                "--dry-run"
              ]
              ++ optionals cmds.skipQbVersionCheck [
                "--skip-qb-version-check"
              ];

              flags = [
                "--config-dir ${cfg.dataDir}"
              ]
              ++ logFlags
              ++ webServerFlags
              ++ commandFlags;
            in
            "${lib.getExe cfg.package} ${lib.concatStringsSep " " flags}";

          EnvironmentFile = mkIf (cfg.environmentFile != null) cfg.environmentFile;

          # Hardening
          AmbientCapabilities = [ "" ];
          CapabilityBoundingSet = [ "" ];
          DevicePolicy = "closed";
          KeyringMode = "private";
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
          ProtectSystem = "full";
          RemoveIPC = true;
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
            "AF_NETLINK"
            "AF_UNIX"
          ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          MemoryDenyWriteExecute = true;
          SystemCallArchitecture = "native";
          SystemCallFilter = [
            "~@cpu-emulation"
            "~@debug"
            "~@mount"
            "~@obsolete"
            "~@privileged"
            "~@resources"
          ];
        };
      };
    };
  };
  meta.maintainers = with lib.maintainers; [
    flyingPeakock
  ];
}
