{ config
, lib
, pkgs
, ...
}:

let
  inherit (lib) types;
  magicUUID = "urn:uuid:4bd2d7e2-31d0-37d4-4399-08db6a587dd3"; # Arbitrary UUID, must remain constant
  papplConfigOptions = {
    dnssdName = lib.mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        The name of the service as it appears in DNS-SD.
      '';
    };
    contact = lib.mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        The contact information for the service.
      '';
    };
    maxImageSize = lib.mkOption {
      type = types.submodule {
        options = {
          maxSize = lib.mkOption {
            type = types.int;
            default = 0;
            description = ''
              The maximum image size in bytes.
            '';
          };
          width = lib.mkOption {
            type = types.int;
            default = 0;
            description = ''
              The maximum image width in pixels.
            '';
          };
          height = lib.mkOption {
            type = types.int;
            default = 0;
            description = ''
              The maximum image height in pixels.
            '';
          };
        };
      };
      description = ''
        The maximum image size.
      '';
    };
  };
  globalPapplConfigType = types.submodule {
    options = {
      defaultPrinterID = lib.mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          The ID of the default printer.
        '';
      };
    } // papplConfigOptions;
  };
  printerConfigType = types.submodule {
    options = {
      driver = lib.mkOption {
        type = types.enum [
          # lprint drivers | grep -oE "^[^ ]+" | xargs printf "\"%s\"\n"
          "brother_ql-500"
          "brother_ql-550"
          "brother_ql-560"
          "brother_ql-570"
          "brother_ql-580n"
          "brother_ql-600"
          "brother_ql-650td"
          "brother_ql-700"
          "brother_ql-710w"
          "brother_ql-720nw"
          "brother_ql-800"
          "brother_ql-810w"
          "brother_ql-820nwb"
          "brother_ql-1050"
          "brother_ql-1060n"
          "brother_ql-1100"
          "brother_ql-1110nwb"
          "brother_ql-1115nwb"
          "cpcl-203dpi"
          "dymo_lm-400"
          "dymo_lm-450"
          "dymo_lm-pc"
          "dymo_lm-pc-ii"
          "dymo_lm-pnp"
          "dymo_lp-350"
          "dymo_lw-300"
          "dymo_lw-310"
          "dymo_lw-315"
          "dymo_lw-320"
          "dymo_lw-330"
          "dymo_lw-330-turbo"
          "dymo_lw-400"
          "dymo_lw-400-turbo"
          "dymo_lw-450"
          "dymo_lw-450-duo-label"
          "dymo_lw-450-duo-tape"
          "dymo_lw-450-turbo"
          "dymo_lw-450-twin-turbo"
          "dymo_lw-4xl"
          "dymo_lw-duo-label"
          "dymo_lw-duo-tape"
          "dymo_lw-duo-tape-128"
          "dymo_lw-se450"
          "epl2_2inch-203dpi-dt"
          "epl2_2inch-203dpi-tt"
          "epl2_2inch-300dpi-dt"
          "epl2_2inch-300dpi-tt"
          "epl2_4inch-203dpi-dt"
          "epl2_4inch-203dpi-tt"
          "epl2_4inch-300dpi-dt"
          "epl2_4inch-300dpi-tt"
          "sii_slp100_203dpi"
          "sii_slp200_203dpi"
          "sii_slp240_203dpi"
          "sii_slp410_203dpi"
          "sii_slp420_203dpi"
          "sii_slp430_203dpi"
          "sii_slp440_300dpi"
          "sii_slp450_300dpi"
          "sii_slp620_203dpi"
          "sii_slp650_300dpi"
          "sii_slp650se_300dpi"
          "tspl_203dpi"
          "tspl_rollo-x1038_203dpi"
          "tspl_300dpi"
          "zpl_2inch-203dpi-dt"
          "zpl_2inch-203dpi-dt_zd611"
          "zpl_2inch-203dpi-tt"
          "zpl_2inch-300dpi-dt"
          "zpl_2inch-300dpi-dt_zd611"
          "zpl_2inch-300dpi-tt"
          "zpl_2inch-600dpi-tt"
          "zpl_4inch-203dpi-dt"
          "zpl_4inch-203dpi-dt_gx420d"
          "zpl_4inch-203dpi-dt_gx430d"
          "zpl_4inch-203dpi-dt_zd621"
          "zpl_4inch-203dpi-tt"
          "zpl_4inch-203dpi-tt_gx420t"
          "zpl_4inch-203dpi-tt_gx430t"
          "zpl_4inch-300dpi-dt"
          "zpl_4inch-300dpi-dt_zd621"
          "zpl_4inch-300dpi-tt"
          "zpl_4inch-600dpi-tt"
        ];
        default = null;
        description = ''
          The driver for the printer.
        '';
      };
      name = lib.mkOption {
        type = types.str;
        description = ''
          The name of the printer.
        '';
      };
      uri = lib.mkOption {
        type = types.str;
        description = ''
          The URI of the printer.
        '';
      };
    };
  };
  mediaCollectionType = types.submodule {
    options = {
      name = lib.mkOption {
        type = types.str;
        description = ''
          The name of the media.
        '';
      };
      bottom = lib.mkOption {
        type = types.int;
        description = ''
          The bottom margin.
        '';
      };
      top = lib.mkOption {
        type = types.int;
        description = ''
          The top margin.
        '';
      };
      left = lib.mkOption {
        type = types.int;
        description = ''
          The left margin.
        '';
      };
      right = lib.mkOption {
        type = types.int;
        description = ''
          The right margin.
        '';
      };
      width = lib.mkOption {
        type = types.int;
        description = ''
          The width of the media.
        '';
      };
      length = lib.mkOption {
        type = types.int;
        description = ''
          The length of the media.
        '';
      };
      source = lib.mkOption {
        type = types.str;
        description = ''
          The source of the media.
        '';
      };
      tracking = lib.mkOption {
        type = types.str;
        description = ''
          The tracking of the media.
        '';
      };
      type = lib.mkOption {
        type = types.str;
        description = ''
          The type of the media.
        '';
      };
    };
  };
  printerPapplConfigType = types.submodule {
    options = {
      maxActiveJobs = lib.mkOption {
        type = types.int;
        default = 0;
        description = ''
          The maximum number of active jobs.
        '';
      };
      maxCompletedJobs = lib.mkOption {
        type = types.int;
        default = 0;
        description = ''
          The maximum number of completed jobs.
        '';
      };
      defaultMediaCollection = lib.mkOption {
        type = mediaCollectionType;
        description = ''
          The default media collection.
        '';
      };
      additionalMediaCollections = lib.mkOption {
        type = types.listOf mediaCollectionType;
        default = [];
        description = ''
          Additional media collections.
        '';
      };
      defaultOrientation = lib.mkOption {
        type = types.enum [
          "portrait"
          "landscape"
          "reverse-landscape"
          "reverse-portrait"
          "none"
        ];
        default = "none";
        description = ''
          The default orientation.
        '';
      };
      defaultColorMode = lib.mkOption {
        type = types.enum [
          "auto"
          "color"
          "monochrome"
        ];
        default = "auto";
        description = ''
          The default color mode.
        '';
      };
      defaultContentOptimize = lib.mkOption {
        type = types.enum [
          "auto"
          "graphic"
          "photo"
          "text"
          "text-and-graphic"
        ];
        default = "auto";
        description = ''
          The default content optimize.
        '';
      };
      defaultPrintQuality = lib.mkOption {
        type = types.enum [
          "draft"
          "normal"
          "high"
        ];
        default = "normal";
        description = ''
          The default print quality.
        '';
      };
      defaultPrintScaling = lib.mkOption {
        type = types.enum [
          "auto"
          "auto-fit"
          "fit"
          "fill"
          "none"
        ];
        default = "auto";
        description = ''
          The default print scaling.
        '';
      };
      defaultPrintSpeed = lib.mkOption {
        type = types.int;
        default = 0;
        description = ''
          The default print speed.
        '';
      };
      printerDarkness = lib.mkOption {
        type = types.int;
        default = 50;
        description = ''
          The printer darkness.
        '';
      };
      printerResolution = lib.mkOption {
        type = types.str;
        description = ''
          The printer resolution.
        '';
      };
      doubleSided = lib.mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether the printer supports double-sided printing.
        '';
      };
    } // papplConfigOptions;
  };
  cfg = config.services.printing.lprint;
in
{
  options = {
    services.printing.lprint = {
      enable = lib.mkEnableOption "the lprint service.";

      package = lib.mkPackageOption pkgs "lprint" {};

      papplOptions = lib.mkOption {
        type = globalPapplConfigType;
        default = {
          dnssdName = "LPrint";
          contact = "";
        };
        description = ''
          The global PAPPL options.
        '';
      };

      printers = lib.mkOption {
        type = types.attrsOf (types.submodule {
          options = {
            printerOptions = lib.mkOption {
              type = printerConfigType;
              description = ''
                The printer options.
              '';
            };
            papplOptions = lib.mkOption {
              type = printerPapplConfigType;
              description = ''
                The per-printer PAPPL options.
              '';
            };
          };
        });
        description = ''
          Printer configuration.
        '';
      };
    };
  };

  # Implementation
  config = lib.mkIf cfg.enable {
    services.avahi = {
      enable = true;
      publish = {
        enable = true;
        userServices = true;
      };
    };

    systemd.services.lprint = {
      description = "LPrint Service";
      after = [ "network.target" "nss-lookup.target" ];
      requires = [ "avahi-daemon.socket" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${lib.getExe cfg.package} server -o log-file=- -o log-level=info";
        Restart = "on-failure";
        RestartSec = 5;
        User = "lprint";
        Group = "lprint";
      };
    };

    users.users.lprint = {
      isSystemUser = true;
      group = "lprint";
      extraGroups = [ "usb" "lp" ];
    };

    environment.etc."lprint.conf".text = ''
      ${lib.optionalString (cfg.papplOptions.dnssdName != null) "DNSSDName ${cfg.papplOptions.dnssdName}"}
      ${lib.optionalString (cfg.papplOptions.contact != null) "Contact ${cfg.papplOptions.contact}"}
      ${lib.optionalString (cfg.papplOptions.defaultPrinterID != null) "DefaultPrinterID ${cfg.papplOptions.defaultPrinterID}"}
      ${lib.optionalString (cfg.papplOptions.maxImageSize != null) "MaxImageSize ${toString cfg.papplOptions.maxImageSize.maxSize} ${toString cfg.papplOptions.maxImageSize.width} ${toString cfg.papplOptions.maxImageSize.height}"}
      UUID ${magicUUID}
    '' + (lib.concatLines (lib.mapAttrsToList (printerId: (printerConfig: {
      name = printerId;
      config = ''
        <Printer did="" driver="${printerConfig.printerOptions.driver}" id="${printerId}" name="${printerConfig.printerOptions.name}" state="3" uri="${printerConfig.printerOptions.uri}">
        ${lib.optionalString (printerConfig.papplOptions.dnssdName != null) "DNSSDName ${printerConfig.papplOptions.dnssdName}"}
        ${lib.optionalString (printerConfig.papplOptions.contact != null) "Contact ${printerConfig.papplOptions.contact}"}
        ${lib.optionalString (printerConfig.papplOptions.maxImageSize != null) "MaxImageSize ${toString printerConfig.papplOptions.maxImageSize.maxSize} ${toString cfg.papplOptions.maxImageSize.width} ${toString cfg.papplOptions.maxImageSize.height}"}
        MaxActiveJobs ${toString printerConfig.papplOptions.maxActiveJobs}
        MaxCompletedJobs ${toString printerConfig.papplOptions.maxCompletedJobs}
        NextJobId 1
        ImpressionsCompleted 0
        media-col-default bottom="${toString printerConfig.papplOptions.defaultMediaCollection.bottom}" left="${toString printerConfig.papplOptions.defaultMediaCollection.left}" length="${toString printerConfig.papplOptions.defaultMediaCollection.length}" name="${printerConfig.papplOptions.defaultMediaCollection.name}" right="${toString printerConfig.papplOptions.defaultMediaCollection.right}" source="${printerConfig.papplOptions.defaultMediaCollection.source}" top="${toString printerConfig.papplOptions.defaultMediaCollection.top}" tracking="${printerConfig.papplOptions.defaultMediaCollection.tracking}" type="${printerConfig.papplOptions.defaultMediaCollection.type}" width="${toString printerConfig.papplOptions.defaultMediaCollection.width}"
        media-col-ready0 bottom="${toString printerConfig.papplOptions.defaultMediaCollection.bottom}" left="${toString printerConfig.papplOptions.defaultMediaCollection.left}" length="${toString printerConfig.papplOptions.defaultMediaCollection.length}" name="${printerConfig.papplOptions.defaultMediaCollection.name}" right="${toString printerConfig.papplOptions.defaultMediaCollection.right}" source="${printerConfig.papplOptions.defaultMediaCollection.source}" top="${toString printerConfig.papplOptions.defaultMediaCollection.top}" tracking="${printerConfig.papplOptions.defaultMediaCollection.tracking}" type="${printerConfig.papplOptions.defaultMediaCollection.type}" width="${toString printerConfig.papplOptions.defaultMediaCollection.width}"
        ${
          lib.concatLines (lib.mapAttrsToList (mediaCollectionId: mediaCollectionConfig: ''
            media-col-ready${toString (mediaCollectionId + 1)} bottom="${toString mediaCollectionConfig.bottom}" left="${toString mediaCollectionConfig.left}" length="${toString mediaCollectionConfig.length}" name="${mediaCollectionConfig.name}" right="${toString mediaCollectionConfig.right}" source="${mediaCollectionConfig.source}" top="${toString mediaCollectionConfig.top}" tracking="${mediaCollectionConfig.tracking}" type="${mediaCollectionConfig.type}" width="${toString mediaCollectionConfig.width}"
          '') printerConfig.papplOptions.additionalMediaCollections)
        }
        orientation-requested-default ${printerConfig.papplOptions.defaultOrientation}
        print-color-mode-default ${printerConfig.papplOptions.defaultColorMode}
        print-content-optimize-default ${printerConfig.papplOptions.defaultContentOptimize}
        print-quality-default ${printerConfig.papplOptions.defaultPrintQuality}
        print-scaling-default ${printerConfig.papplOptions.defaultPrintScaling}
        print-speed-default ${toString printerConfig.papplOptions.defaultPrintSpeed}
        printer-darkness-configured ${toString printerConfig.papplOptions.printerDarkness}
        printer-resolution-default ${printerConfig.papplOptions.printerResolution}
        sides-default ${if printerConfig.papplOptions.doubleSided then "two-sided-long-edge" else "one-sided"}
        </Printer>
      '';
    })) cfg.printers));
  };

  # Metadata
  meta = {
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
}
