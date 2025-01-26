{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.programs.ccache;
in
{
  options.programs.ccache = {
    # host configuration
    enable = lib.mkEnableOption "CCache, a compiler cache for fast recompilation of C/C++ code";
    cacheDir = lib.mkOption {
      type = lib.types.path;
      description = "CCache directory";
      default = "/var/cache/ccache";
    };
    # target configuration
    packageNames = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "Nix top-level packages to be compiled using CCache";
      default = [ ];
      example = [
        "wxGTK32"
        "ffmpeg"
        "libav_all"
      ];
    };
    owner = lib.mkOption {
      type = lib.types.str;
      default = "root";
      description = "Owner of CCache directory";
    };
    group = lib.mkOption {
      type = lib.types.str;
      default = "nixbld";
      description = "Group owner of CCache directory";
    };
  };

  config = lib.mkMerge [
    # host configuration
    (lib.mkIf cfg.enable {
      systemd.tmpfiles.rules = [ "d ${cfg.cacheDir} 0770 ${cfg.owner} ${cfg.group} -" ];

      # "nix-ccache --show-stats" and "nix-ccache --clear"
      security.wrappers.nix-ccache = {
        inherit (cfg) owner group;
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
    (lib.mkIf (cfg.packageNames != [ ]) {
      nixpkgs.overlays = [
        (
          self: super:
          lib.genAttrs cfg.packageNames (
            pn: super.${pn}.override { stdenv = builtins.trace "with ccache: ${pn}" self.ccacheStdenv; }
          )
        )

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
                echo "  sudo chown ${cfg.owner}:${cfg.group} '$CCACHE_DIR'"
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
