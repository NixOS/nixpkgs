{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.hardware.printers;
  ppdOptionsString = options: optionalString (options != {})
    (concatStringsSep " "
      (mapAttrsToList (name: value: "-o '${name}'='${value}'") options)
    );
  ensurePrinter = p: ''
    ${pkgs.cups}/bin/lpadmin -p '${p.name}' -E \
      ${optionalString (p.location != null) "-L '${p.location}'"} \
      ${optionalString (p.description != null) "-D '${p.description}'"} \
      -v '${p.deviceUri}' \
      -m '${p.model}' \
      ${ppdOptionsString p.ppdOptions}
  '';
  ensureDefaultPrinter = name: ''
    ${pkgs.cups}/bin/lpadmin -d '${name}'
  '';

  # "graph but not # or /" can't be implemented as regex alone due to missing lookahead support
  noInvalidChars = str: all (c: c != "#" && c != "/") (stringToCharacters str);
  printerName = (types.addCheck (types.strMatching "[[:graph:]]+") noInvalidChars)
    // { description = "printable string without spaces, # and /"; };


in {
  options = {
    hardware.printers = {
      ensureDefaultPrinter = mkOption {
        type = types.nullOr printerName;
        default = null;
        description = lib.mdDoc ''
          Ensures the named printer is the default CUPS printer / printer queue.
        '';
      };
      ensurePrinters = mkOption {
        description = lib.mdDoc ''
          Will regularly ensure that the given CUPS printers are configured as declared here.
          If a printer's options are manually changed afterwards, they will be overwritten eventually.
          This option will never delete any printer, even if removed from this list.
          You can check existing printers with {command}`lpstat -s`
          and remove printers with {command}`lpadmin -x <printer-name>`.
          Printers not listed here can still be manually configured.
        '';
        default = [];
        type = types.listOf (types.submodule {
          options = {
            name = mkOption {
              type = printerName;
              example = "BrotherHL_Workroom";
              description = lib.mdDoc ''
                Name of the printer / printer queue.
                May contain any printable characters except "/", "#", and space.
              '';
            };
            location = mkOption {
              type = types.nullOr types.str;
              default = null;
              example = "Workroom";
              description = lib.mdDoc ''
                Optional human-readable location.
              '';
            };
            description = mkOption {
              type = types.nullOr types.str;
              default = null;
              example = "Brother HL-5140";
              description = lib.mdDoc ''
                Optional human-readable description.
              '';
            };
            deviceUri = mkOption {
              type = types.str;
              example = literalExpression ''
                "ipp://printserver.local/printers/BrotherHL_Workroom"
                "usb://HP/DESKJET%20940C?serial=CN16E6C364BH"
              '';
              description = lib.mdDoc ''
                How to reach the printer.
                {command}`lpinfo -v` shows a list of supported device URIs and schemes.
              '';
            };
            model = mkOption {
              type = types.str;
              example = literalExpression ''
                "gutenprint.''${lib.versions.majorMinor (lib.getVersion pkgs.gutenprint)}://brother-hl-5140/expert"
              '';
              description = lib.mdDoc ''
                Location of the ppd driver file for the printer.
                {command}`lpinfo -m` shows a list of supported models.
              '';
            };
            ppdOptions = mkOption {
              type = types.attrsOf types.str;
              example = {
                PageSize = "A4";
                Duplex = "DuplexNoTumble";
              };
              default = {};
              description = lib.mdDoc ''
                Sets PPD options for the printer.
                {command}`lpoptions [-p printername] -l` shows supported PPD options for the given printer.
              '';
            };
          };
        });
      };
    };
  };

  config = mkIf (cfg.ensurePrinters != [] && config.services.printing.enable) {
    systemd.services.ensure-printers = {
      description = "Ensure NixOS-configured CUPS printers";
      wantedBy = [ "multi-user.target" ];
      wants = [ "cups.service" ];
      after = [ "cups.service" ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };

      script = concatStringsSep "\n" [
        (concatMapStrings ensurePrinter cfg.ensurePrinters)
        (optionalString (cfg.ensureDefaultPrinter != null)
          (ensureDefaultPrinter cfg.ensureDefaultPrinter))
        # Note: if cupsd is "stateless" the service can't be stopped,
        # otherwise the configuration will be wiped on the next start.
        (optionalString (with config.services.printing; startWhenNeeded && !stateless)
          "systemctl stop cups.service")
      ];
    };
  };
}
