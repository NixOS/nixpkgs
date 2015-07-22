{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.boot.loader.raspberryPi;

  builder = pkgs.substituteAll {
    src = ./builder.sh;
    isExecutable = true;
    inherit (pkgs) bash;
    path = [pkgs.coreutils pkgs.gnused pkgs.gnugrep];
    firmware = pkgs.raspberrypifw;
    version = cfg.version;
  };

  platform = pkgs.stdenv.platform;

in

{
  options = {

    boot.loader.raspberryPi.enable = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Whether to create files with the system generations in
        <literal>/boot</literal>.
        <literal>/boot/old</literal> will hold files from old generations.
      '';
    };

    boot.loader.raspberryPi.version = mkOption {
      default = 2;
      type = types.int;
      description = ''
      '';
    };

  };

  config = mkIf config.boot.loader.raspberryPi.enable {
    system.build.installBootLoader = builder;
    system.boot.loader.id = "raspberrypi";
    system.boot.loader.kernelFile = platform.kernelTarget;
    assertions = [
      { assertion = (cfg.version == 1 || cfg.version == 2);
        message = "loader.raspberryPi.version should be 1 or 2";
      }
    ];
  };
}
