{pkgs, config, ...}:

###### interface
let
  inherit (pkgs.lib) mkOption mkIf;

  options = {
    boot = {
      loader = {
        generationsDir = {

          enable = mkOption {
            default = false;
            description = ''
              Whether to enable the simple preparation of symlinks to the system
              generations in /boot.
            '';
          };

          copyKernels = mkOption {
            default = false;
            description = "
              Whether copy the necessary boot files into /boot, so
              /nix/store is not needed by the boot loadear.
            ";
          };
        };
      };
    };
  };

in

###### implementation
let
  generationsDirBuilder = pkgs.substituteAll {
    src = ./generations-dir-builder.sh;
    isExecutable = true;
    inherit (pkgs) bash;
    path = [pkgs.coreutils pkgs.gnused pkgs.gnugrep];
    inherit (config.boot.loader.generationsDir) copyKernels;
  };

  # Temporary check, for nixos to cope both with nixpkgs stdenv-updates and trunk
  platform = pkgs.stdenv.platform;
in
{
  require = [
    options

    # config.system.build
    # ../system/system-options.nix
  ];

  system = mkIf config.boot.loader.generationsDir.enable {
    build = {
      menuBuilder = generationsDirBuilder;
    };
    boot.loader.id = "generationsDir";
    boot.loader.kernelFile = platform.kernelTarget;
  };
}
