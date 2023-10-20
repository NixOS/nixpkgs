{ config, lib, pkgs, ... }:

let
  cfg = config.programs.keyutils;

  keyProgram = with lib;
    types.submodule {
      options = {
        op = mkOption {
          type = types.str;
          example = "create";
          description = mdDoc "The requested key operation to match.";
        };
        type = mkOption {
          type = types.str;
          default = "*";
          example = "user";
          description = mdDoc "The requested key type to match.";
        };
        description = mkOption {
          type = types.str;
          default = "*";
          example = "debug:*";
          description = mdDoc "The requested key description to match.";
        };
        calloutInfo = mkOption {
          type = types.str;
          default = "*";
          example = "negate";
          description = mdDoc "The requested key callout info to match.";
        };
        command = mkOption {
          type = types.str;
          example = literalExpression
            ''"''${pkgs.keyutils}/bin/keyctl negate %k 30 %S"'';
          description = mdDoc ''
            The command to execute to generate the key.

            See {manpage}`request-key.conf(5)` for information on available substitutions.
          '';
        };
      };
    };
in {
  options.programs.keyutils = with lib; {
    enable = mkEnableOption (mdDoc
      "configuration of userspace utilities for Linux keyring management");

    package = mkPackageOptionMD pkgs "keyutils" { };

    keyPrograms = mkOption {
      type = types.listOf keyProgram;
      default = [ ];
      description = mdDoc ''
        A list of attrsets describing what programs to use to instantiate keys.

        See {manpage}`request-key.conf(5)`.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."request-key.conf".text = let
      configLines = lib.concatStringsSep "\n" (builtins.map
        (p: "${p.op} ${p.type} ${p.description} ${p.calloutInfo} ${p.command}")
        cfg.keyPrograms);
    in ''
      create user         debug:loop:* *        |${pkgs.coreutils}/bin/cat
      create user         debug:*      negate   ${cfg.package}/bin/keyctl negate %k 30 %S
      create user         debug:*      rejected ${cfg.package}/bin/keyctl reject %k 30 %c %S
      create user         debug:*      expired  ${cfg.package}/bin/keyctl reject %k 30 %c %S
      create user         debug:*      revoked  ${cfg.package}/bin/keyctl reject %k 30 %c %S
      create user         debug:*      *        ${cfg.package}/share/keyutils/request-key-debug.sh %k %d %c %S
      create dns_resolver *            *        ${cfg.package}/bin/key.dns_resolver %k

      ${configLines}
    '';
  };
}
