{ config, pkgs, ... }:

with pkgs.lib;

let

  builder = pkgs.substituteAll {
    src = ./builder.sh;
    isExecutable = true;
    inherit (pkgs) bash;
    path = [pkgs.coreutils pkgs.gnused pkgs.gnugrep];
    firmware = pkgs.raspberrypifw;
  };

  platform = pkgs.stdenv.platform;

in

{
  options = {

    boot.loader.raspberryPi.enable = mkOption {
      default = false;
      description = ''
        Whether to create files with the system generations in
        <literal>/boot</literal>.
        <literal>/boot/old</literal> will hold files from old generations.
      '';
    };

  };

  config = mkIf config.boot.loader.raspberryPi.enable {
    system.build.installBootLoader = builder;
    system.boot.loader.id = "raspberrypi";
    system.boot.loader.kernelFile = platform.kernelTarget;
  };
}
