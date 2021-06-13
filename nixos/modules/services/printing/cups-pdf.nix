{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.printing.cups-pdf;

  reminder = ''
    ### Don't edit this file. Set the NixOS option
    ### ‘services.printing.cups-pdf.configurations’
    ###
    ### Read docs and find default config in
    ### ${pkgs.cups-pdf}/share/doc


  '';

in

{

  options = {

    services.printing.cups-pdf = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable virtual PDF printer for CUPS.
        '';
      };

      configurations = mkOption {
        type = types.attrsOf types.str;
        default = {};
        description = ''
          Configuration names and their associated definitions.
        '';
        example = literalExample ''
          { cups-pdf = '''
              Out ''${HOME}/printed
            ''';
             cups-pdf-PDF-debug = '''
              LogType 7
            ''';
          }
        '';
      };

    };

  };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [ cups-pdf ];
    services.printing.drivers = with pkgs; [ cups-pdf ];

    security.wrappers.cups-pdf = {
      source = "${pkgs.cups-pdf}/lib/cups/backend.orig/cups-pdf";
      owner = "root";
      group = "root";
      permissions = "u+rwx,g-rwx,o-rwx";
    };

    ###  From README file:
    ###  ----------------
    ###  To create multiple instances of the backend with different configurations, simply
    ###  copy several config files in your config directory, naming them
    ###  cups-pdf-<NAME>.conf, where <NAME> is a unique identifier for this instance.
    ###  You can then select the new instances as URI when creating a new printer in CUPS.
    environment.etc = mapAttrs' (name: value: {
      name = "cups-pdf/${name}.conf";
      value = { text = reminder + value; };
    }) cfg.configurations;

  };

}
