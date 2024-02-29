{ config, lib, utils, ... }:

with lib;

let
  cfg = config.boot.loader.external;
in
{
  meta = {
    maintainers = with maintainers; [ cole-h grahamc raitobezarius ];
    doc = ./external.md;
  };

  options.boot.loader.external = utils.mkBootLoaderOption {
    enable = mkEnableOption (lib.mdDoc "use an external tool to install your bootloader");

    id = mkOption {
      type = types.str;
      description = lib.mdDoc "Identifier of this external bootloader for metadata";
    };

    installHook = mkOption {
      type = with types; path;
      description = lib.mdDoc ''
        The full path to a program of your choosing which performs the bootloader installation process.

        The program will be called with an argument pointing to the output of the system's toplevel.
      '';
    };
  };

  config = mkIf cfg.enable {
    boot.loader.external.supportsInitrdSecrets = mkDefault false;
  };
}
