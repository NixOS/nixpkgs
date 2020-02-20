{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.hardware.printers;
  ppdOptionsString = options: optionalString (options != {})
    (concatStringsSep " "
      (mapAttrsToList (name: value: "-o '${name}'='${value}'") options)
    );
  ensurePrinter = p:
    assert (p.model or null) == null || (p.ppd or null) == null;
    assert (p.model or null) != null || (p.ppd or null) != null;
    ''
    ${pkgs.cups}/bin/lpadmin -p '${p.name}' -E \
      ${optionalString (p.location != null) "-L '${p.location}'"} \
      ${optionalString (p.description != null) "-D '${p.description}'"} \
      -v '${p.deviceUri}' \
      ${if (p.model or null) != null then "-m '${p.model}'" else ""} \
      ${if (p.ppd or null) != null then "-P '${p.ppd}'" else ""} \
      ${ppdOptionsString p.ppdOptions}
  '';
  ensureDefaultPrinter = name: ''
    ${pkgs.cups}/bin/lpoptions -d '${name}'
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
        description = ''
          Ensures the named printer is the default CUPS printer / printer queue.
        '';
      };
      ensurePrinters = mkOption {
        description = ''
          Will regularly ensure that the given CUPS printers are configured as declared here.
          If a printer's options are manually changed afterwards, they will be overwritten eventually.
          This option will never delete any printer, even if removed from this list.
          You can check existing printers with <command>lpstat -s</command>
          and remove printers with <command>lpadmin -x &lt;printer-name&gt;</command>.
          Printers not listed here can still be manually configured.
        '';
        default = [];
        type = types.listOf (types.submodule {
          options = {
            name = mkOption {
              type = printerName;
              example = "BrotherHL_Workroom";
              description = ''
                Name of the printer / printer queue.
                May contain any printable characters except "/", "#", and space.
              '';
            };
            location = mkOption {
              type = types.nullOr types.str;
              default = null;
              example = "Workroom";
              description = ''
                Optional human-readable location.
              '';
            };
            description = mkOption {
              type = types.nullOr types.str;
              default = null;
              example = "Brother HL-5140";
              description = ''
                Optional human-readable description.
              '';
            };
            deviceUri = mkOption {
              type = types.str;
              example = [
                "ipp://printserver.local/printers/BrotherHL_Workroom"
                "usb://HP/DESKJET%20940C?serial=CN16E6C364BH"
              ];
              description = ''
                How to reach the printer.
                <command>lpinfo -v</command> shows a list of supported device URIs and schemes.
              '';
            };
            model = mkOption {
              type = types.nullOr types.str;
              example = literalExample ''
                gutenprint.''${lib.version.majorMinor (lib.getVersion pkgs.cups)}://brother-hl-5140/expert
              '';
              default = null;
              description = ''
                Model of the printer, in the form of a path to an installed PPD file.
                <command>lpinfo -m</command> shows a list of supported models.
                This option is incompatible with the `ppd` option.
              '';
            };
            ppd = mkOption {
              type = types.nullOr types.path;
              example = literalExample ''
                ./path/to/some_printer.ppd
              '';
              default = null;
              description = ''
                Path to a PPD file for the printer, usually supplied by the printer manufacturer.
                The PPD does not need to be installed.
                This option is incompatible with the `model` option.
              '';
            };
            ppdOptions = mkOption {
              type = types.attrsOf types.str;
              example = {
                PageSize = "A4";
                Duplex = "DuplexNoTumble";
              };
              default = {};
              description = ''
                Sets PPD options for the printer.
                <command>lpoptions [-p printername] -l</command> shows suported PPD options for the given printer.
              '';
            };
          };
        });
      };
    };
  };

  config = mkIf (cfg.ensurePrinters != [] && config.services.printing.enable) {
    systemd.services.ensure-printers = let
      cupsUnit = if config.services.printing.startWhenNeeded then "cups.socket" else "cups.service";
    in {
      description = "Ensure NixOS-configured CUPS printers";
      wantedBy = [ "multi-user.target" ];
      requires = [ cupsUnit ];
      # in contrast to cups.socket, for cups.service, this is actually not enough,
      # as the cups service reports its activation before clients can actually interact with it.
      # Because of this, commands like `lpinfo -v` will report a bad file descriptor
      # due to the missing UNIX socket without sufficient sleep time.
      after = [ cupsUnit ];

      serviceConfig = {
        Type = "oneshot";
      };

       # sleep 10 is required to wait until cups.service is actually initialized and has created its UNIX socket file
      script = (optionalString (!config.services.printing.startWhenNeeded) "sleep 10\n")
        + (concatMapStringsSep "\n" ensurePrinter cfg.ensurePrinters)
        + optionalString (cfg.ensureDefaultPrinter != null) (ensureDefaultPrinter cfg.ensureDefaultPrinter);
    };
  };
}
