{pkgs, config, ...}:

###### interface
let
  inherit (pkgs.lib) mkOption mkIf;

  options = {
    boot = {
      loader = {
        raspberryPi = {
          enable = mkOption {
            default = false;
            description = ''
              Whether to create files with the system generations in
              <literal>/boot</literal>. 
              <literal>/boot/old</literal> will hold files from old generations.
            '';
          };
        };
      };
    };
  };

in

###### implementation
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
  require = [
    options

    # config.system.build
    # ../system/system-options.nix
  ];

  system = mkIf config.boot.loader.raspberryPi.enable {
    build.installBootLoader = builder;
    boot.loader.id = "raspberrypi";
    boot.loader.kernelFile = platform.kernelTarget;
  };
}
