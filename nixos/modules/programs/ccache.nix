{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.programs.ccache;
in {
  options.programs.ccache = {
    # host configuration
    enable = mkEnableOption (lib.mdDoc "CCache");
    cacheDir = mkOption {
      type = types.path;
      description = lib.mdDoc "CCache directory";
      default = "/var/cache/ccache";
    };
    # target configuration
    packageNames = mkOption {
      type = types.listOf types.str;
      description = lib.mdDoc "Nix top-level packages to be compiled using CCache";
      default = [];
      example = [ "wxGTK32" "ffmpeg" "libav_all" ];
    };
  };

  config = mkMerge [
    # host configuration
    (mkIf cfg.enable {
      systemd.tmpfiles.rules = [ "d ${cfg.cacheDir} 0770 root nixbld -" ];

      # "nix-ccache --show-stats" and "nix-ccache --clear"
      security.wrappers.nix-ccache = {
        owner = "root";
        group = "nixbld";
        setuid = false;
        setgid = true;
        source = pkgs.writeScript "nix-ccache.pl" ''
          #!${pkgs.perl}/bin/perl

          %ENV=( CCACHE_DIR => '${cfg.cacheDir}' );
          sub untaint {
            my $v = shift;
            return '-C' if $v eq '-C' || $v eq '--clear';
            return '-V' if $v eq '-V' || $v eq '--version';
            return '-s' if $v eq '-s' || $v eq '--show-stats';
            return '-z' if $v eq '-z' || $v eq '--zero-stats';
            exec('${pkgs.ccache}/bin/ccache', '-h');
          }
          exec('${pkgs.ccache}/bin/ccache', map { untaint $_ } @ARGV);
        '';
      };
    })

    # target configuration
    (mkIf (cfg.packageNames != []) {
      nixpkgs.overlays = [
        (self: super: genAttrs cfg.packageNames (pn: super.${pn}.override { stdenv = builtins.trace "with ccache: ${pn}" self.ccacheStdenv; }))

        (self: super: {
          ccacheWrapper = super.ccacheWrapper.override {
            extraConfig = ''
              export CCACHE_COMPRESS=1
              export CCACHE_DIR="${cfg.cacheDir}"
              export CCACHE_UMASK=007
              if [ ! -d "$CCACHE_DIR" ]; then
                echo "====="
                echo "Directory '$CCACHE_DIR' does not exist"
                echo "Please create it with:"
                echo "  sudo mkdir -m0770 '$CCACHE_DIR'"
                echo "  sudo chown root:nixbld '$CCACHE_DIR'"
                echo "====="
                exit 1
              fi
              if [ ! -w "$CCACHE_DIR" ]; then
                echo "====="
                echo "Directory '$CCACHE_DIR' is not accessible for user $(whoami)"
                echo "Please verify its access permissions"
                echo "====="
                exit 1
              fi
            '';
          };
        })
      ];
    })
  ];
}
