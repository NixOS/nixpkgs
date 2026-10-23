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
        "wxwidgets_3_2"
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
    trace = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Trace ccache usage to see which derivations use ccache";
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
        source = lib.getExe (
          (pkgs.writeCBin "nix-ccache" ''
            #include <err.h>
            #include <regex.h>
            #include <unistd.h>

            #define CCACHE "${lib.getExe pkgs.ccache}"

            int main(int argc, char *argv[]) {
              regex_t allowed;
              if (regcomp(&allowed, "^(-[CVsz]|--(clear|version|show-stats|zero-stats))$", REG_EXTENDED | REG_NOSUB))
                err(1, "regcomp");

              // if any arg isn't on the allowlist, run `ccache` w/o args
              for (int i = 1; i < argc; i++)
                if (regexec(&allowed, argv[i], 0, nullptr, 0))
                  argv[1] = nullptr;

              argv[0] = CCACHE;
              execve(CCACHE, argv, (char *[]){ "CCACHE_DIR=${cfg.cacheDir}", nullptr });
              err(127, CCACHE);
            }
          '').overrideAttrs
            { env.NIX_CFLAGS_COMPILE = "-std=c23"; }
        );
      };
    })

    # target configuration
    (lib.mkIf (cfg.packageNames != [ ]) {
      nixpkgs.overlays = [
        (
          self: super:
          lib.genAttrs cfg.packageNames (
            pn:
            super.${pn}.override {
              stdenv =
                if cfg.trace then builtins.trace "with ccache: ${pn}" self.ccacheStdenv else self.ccacheStdenv;
            }
          )
        )

        (self: super: {
          ccacheWrapper = super.ccacheWrapper.override {
            extraConfig = ''
              export CCACHE_COMPRESS=1
              export CCACHE_SLOPPINESS=random_seed
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
