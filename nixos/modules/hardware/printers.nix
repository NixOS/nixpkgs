{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.hardware.printers;

  ensurePrinter =
    p:
    let
      args = lib.cli.toCommandLineShellGNU { } (
        {
          p = p.name;
          v = p.deviceUri;
          m = p.model;
        }
        // lib.optionalAttrs (p.location != null) {
          L = p.location;
        }
        // lib.optionalAttrs (p.description != null) {
          D = p.description;
        }
        // lib.optionalAttrs (p.ppdOptions != { }) {
          o = lib.mapAttrsToList (name: value: "${name}=${value}") p.ppdOptions;
        }
      );
    in
    ''
      # shellcheck disable=SC2016
      ${pkgs.cups}/bin/lpadmin ${args} -E
    '';

  ensureDefaultPrinter = name: ''
    ${pkgs.cups}/bin/lpadmin -d '${name}'
  '';

  # "graph but not # or /" can't be implemented as regex alone due to missing lookahead support
  noInvalidChars = str: lib.all (c: c != "#" && c != "/") (lib.stringToCharacters str);
  printerName = (lib.types.addCheck (lib.types.strMatching "[[:graph:]]+") noInvalidChars) // {
    description = "printable string without spaces, # and /";
  };

in
{
  options = {
    hardware.printers = {
      ensureDefaultPrinter = lib.mkOption {
        type = lib.types.nullOr printerName;
        default = null;
        description = ''
          Ensures the named printer is the default CUPS printer / printer queue.
        '';
      };
      ensurePrinters = lib.mkOption {
        description = ''
          Will regularly ensure that the given CUPS printers are configured as declared here.
          If a printer's options are manually changed afterwards, they will be overwritten eventually.
          This option will never delete any printer, even if removed from this list.
          You can check existing printers with {command}`lpstat -s`
          and remove printers with {command}`lpadmin -x <printer-name>`.
          Printers not listed here can still be manually configured.
        '';
        default = [ ];
        type = lib.types.listOf (
          lib.types.submodule {
            options = {
              name = lib.mkOption {
                type = printerName;
                example = "BrotherHL_Workroom";
                description = ''
                  Name of the printer / printer queue.
                  May contain any printable characters except "/", "#", and space.
                '';
              };
              location = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
                example = "Workroom";
                description = ''
                  Optional human-readable location.
                '';
              };
              description = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
                example = "Brother HL-5140";
                description = ''
                  Optional human-readable description.
                '';
              };
              deviceUri = lib.mkOption {
                type = lib.types.str;
                example = lib.literalExpression ''
                  "ipp://printserver.local/printers/BrotherHL_Workroom"
                  "usb://HP/DESKJET%20940C?serial=CN16E6C364BH"
                '';
                description = ''
                  How to reach the printer.
                  {command}`lpinfo -v` shows a list of supported device URIs and schemes.
                '';
              };
              model = lib.mkOption {
                type = lib.types.str;
                example = lib.literalExpression ''
                  "gutenprint.''${lib.versions.majorMinor (lib.getVersion pkgs.gutenprint)}://brother-hl-5140/expert"
                '';
                description = ''
                  Location of the ppd driver file for the printer.
                  {command}`lpinfo -m` shows a list of supported models.
                '';
              };
              ppdOptions = lib.mkOption {
                type = lib.types.attrsOf lib.types.str;
                example = {
                  PageSize = "A4";
                  Duplex = "DuplexNoTumble";
                };
                default = { };
                description = ''
                  Sets PPD options for the printer.
                  {command}`lpoptions [-p printername] -l` shows supported PPD options for the given printer.
                '';
              };
            };
          }
        );
      };
    };
  };

  config = lib.mkIf (cfg.ensurePrinters != [ ] && config.services.printing.enable) {
    systemd.services.ensure-printers = {
      description = "Ensure NixOS-configured CUPS printers";
      wantedBy = [ "multi-user.target" ];
      wants = [ "cups.service" ];
      after = [ "cups.service" ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };

      script = lib.concatStringsSep "\n" [
        (lib.concatMapStrings ensurePrinter cfg.ensurePrinters)
        (lib.optionalString (cfg.ensureDefaultPrinter != null) (
          ensureDefaultPrinter cfg.ensureDefaultPrinter
        ))
        # Note: if cupsd is "stateless" the service can't be stopped,
        # otherwise the configuration will be wiped on the next start.
        (lib.optionalString (
          with config.services.printing; startWhenNeeded && !stateless
        ) "systemctl stop cups.service")
      ];
    };
  };
}
