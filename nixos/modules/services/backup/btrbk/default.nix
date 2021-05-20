{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.btrbk;
  btrbkOptions = import ./btrbk-options.nix {inherit config lib pkgs;};

  # Different Sections in the config accept different options.
  # Theese sets inherit the respective valid options.
  # The names used here, are the same names as in $(man btrbk.conf)
  optionSections = {
    global = {
      inherit (btrbkOptions)
      snapshotDir extraOptions timestampFormat snapshotCreate incremental
      noauto preserveDayOfWeek sshUser sshIdentity sshCompression sshCipherSpec
      preserveHourOfDay snapshotPreserve snapshotPreserveMin targetPreserve
      targetPreserveMin stream_compress stream_compress_level;
    };

    subvolume = {
      inherit (btrbkOptions)
      snapshotDir extraOptions timestampFormat snapshotName snapshotCreate
      incremental noauto preserveDayOfWeek sshUser sshIdentity sshCompression
      sshCipherSpec preserveHourOfDay snapshotPreserve snapshotPreserveMin
      targetPreserve targetPreserveMin stream_compress stream_compress_level;
    };

    target = {
      inherit (btrbkOptions)
      extraOptions incremental noauto preserveDayOfWeek sshUser sshIdentity
      sshCompression sshCipherSpec preserveHourOfDay targetPreserve
      targetPreserveMin stream_compress stream_compress_level;
    };

    volume = {
      inherit (btrbkOptions)
      snapshotDir extraOptions timestampFormat snapshotCreate incremental
      noauto preserveDayOfWeek sshUser sshIdentity sshCompression sshCipherSpec
      preserveHourOfDay snapshotPreserve snapshotPreserveMin targetPreserve
      targetPreserveMin stream_compress stream_compress_level;
    };
  };

  helpers = {
    # list2lines :: listOf str -> lines
    list2lines =
      inputList: (concatStringsSep "\n" inputList) + "\n";

    # addPrefixes :: listOf str -> listOf str
    addPrefixes =
      lines: map (line: "  " + line) lines;
  };

  # This function will be used if a subsection is given as a set
  # which you would like to do if this subsection should have
  # special options differing from the default or global settings
  #
  # convertEntrys :: attrs -> enum ["subvolume" "target"] -> listOf str
  convertEntrys =
    subentry: subentryType:
    builtins.concatLists
      (map
          (entry: [(subentryType + " " + entry)]
            ++ (helpers.addPrefixes (renderOptions subentry."${entry}")))
          (builtins.attrNames subentry)
      );

  # This function will be used if a subsection is given as list
  # It will put the name of its corrosponding kind of subsection
  # (which is either "subvolume" or "target") in front of the subsections path
  # and return them as a list of strings
  #
  # convertLists :: listOf str -> enum ["subvolume" "target"] -> listOf str
  convertLists =
    subentry: subentryType: map (entry: subentryType + " " + entry) subentry;

  renderVolumes = builtins.concatLists (
    mapAttrsToList (name: value:
      # volume head line
      [ ("volume " + name) ]
      # volume options
      ++ (helpers.addPrefixes (renderOptions value))
      # volume subvolumes which should be backed up
      ++ (renderSubsection value "subvolume")
      # volume backup targets
      ++ (renderSubsection value "target"))
    cfg.volumes);

  # renderSubsection :: attrs -> emum["subvolume" "target"] -> listOf str
  renderSubsection =
    volumeEntry: subsectionType:
      let
        subsectionEntry = builtins.getAttr (subsectionType + "s") volumeEntry;
        converter =
          # differentiate whether a simple list is used,
          # or if extra options are used for the subentry
          if (builtins.isAttrs subsectionEntry)
            then convertEntrys else convertLists;
      in
        (helpers.addPrefixes (converter subsectionEntry subsectionType));

  # A subsection is either typed as a list of strings
  # or in more advanced cases as a list of options which specificly and only
  # applys to this subsection
  #
  # if the later is the case, the bound variable 'options' will be elliminated
  # in favor of the kind of options which can be used with this type of subsection
  subsectionDataType = options: with types; either (listOf str) (attrsOf (submodule
    ({name, config, ...}:
    {
      inherit options;
    }))
  );

  # individual options will be parsed
  #
  # renderOptions :: attrs -> listOf str
  renderOptions = options:
  with builtins; concatLists (attrValues
    (filterAttrs (name: value: builtins.hasAttr name btrbkOptions) options)
  );


  # Each btrfs volume is configured as an option of type submodule
  # The following set specifies this submodule
  #
  # For example
  # services.btrbk."/home/user".subvolumes."Movies".snapshotDir = "/snapshots";
  # will generate the following excerpt in the final config:
  #
  # volume /home/user
  #   subvolume Movies
  #     snapshot_dir = "/snapshots";
  volumeSubmodule =
    ({name, config, ... }:
    {
      options = {
        subvolumes = mkOption {
            type = subsectionDataType optionSections.subvolume;
            default = [];
            example = [ "/home/user/important_data" "/mount/even_more_important_data"];
            description = "A list of subvolumes which should be backed up.";
        };
        targets = mkOption {
          type = subsectionDataType optionSections.target;
          default = [];
          example = ''[ "/mount/backup_drive" ]'';
          description = "A list of targets where backups of this volume should be stored.";
        };
      } // optionSections.volume;
  });
  in {

    meta.maintainers = [ maintainers.voidless ];

    options.services.btrbk = ({
      enable = mkEnableOption
        "Enable the btrbk backup utility for btrfs based file systems.";

      volumes = mkOption {
        type = with types; attrsOf (submodule volumeSubmodule);
        default = { };
        description =
        "The configuration for a specific volume.
        The key of each entry is a string, reflecting the path of that volume.";
        example = {
         "/mount/btrfs_volumes" =
          {
            subvolumes = [ "btrfs_volume/important_files" ];
            targets = [ "/mount/backup_drive" ];
          };
        };
      };
    } // optionSections.global);

    ###### implementation
    config = mkIf cfg.enable {
      environment.systemPackages = [ pkgs.btrbk ];
      environment.etc."btrbk/btrbk.conf" = {
        source = pkgs.writeText "btrbk.conf"
          ( (helpers.list2lines (renderOptions cfg))
            + (helpers.list2lines renderVolumes));
      };
    };
  }
