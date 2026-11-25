{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.programs.ccache;

  ccacheConfigFile = "${pkgs.writeText "ccache.conf" (
    lib.concatMapAttrsStringSep "\n" renderConfigOption (lib.filterAttrs (_: v: v != [ ]) cfg.settings)
  )}";
  renderConfigOption = name: value: "${name} = ${genericToString value}";
  genericToString =
    value:
    if builtins.isBool value then
      lib.boolToString value
    else if builtins.isList value then
      builtins.concatStringsSep " " (map toString value)
    else
      toString value;

  sloppinessEnum = lib.types.enum [
    "clang_index_store"
    "file_stat_matches"
    "file_stat_matches_ctime"
    "gcno_cwd"
    "incbin"
    "include_file_ctime"
    "include_file_mtime"
    "ivfsoverlay"
    "locale"
    "modules"
    "pch_defines"
    "random_seed"
    "system_headers"
    "time_macros"
  ];
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

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = with lib.types; attrsOf anything;
        options = {
          sloppiness = lib.mkOption {
            type = lib.types.listOf sloppinessEnum;
            description = ''
              List of ways for ccache to relax some checks in order to increase
              the hit rate.

              random_seed will remain in the list if other items are added. To
              reset the entire list, use mkForce.
            '';
            defaultText = lib.literalExpression "[ \"random_seed\" ]";
          };
          umask = lib.mkOption {
            type = lib.types.str;
            description = "Specifies the umask for files and directories in the cache directory, as an octal integer.";
            default = "007";
          };
        };
        config.sloppiness = [ "random_seed" ];
      };
      description = "Options for the cache-specific configuration file. See man:ccache(1) for details.";
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
    trace = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Trace ccache usage to see which derivations use ccache";
    };
  };

  config = lib.mkMerge [
    # host configuration
    (lib.mkIf cfg.enable {
      nix.settings.extra-sandbox-paths = [
        cfg.cacheDir
        ccacheConfigFile
        "/etc/ccache.conf=${pkgs.writeText "ccache.conf" ''
          cache_dir = ${cfg.cacheDir}
        ''}"
      ];

      systemd.tmpfiles.settings."10-nixos-ccache" = {
        ${cfg.cacheDir}.d = {
          mode = "0770";
          user = cfg.owner;
          inherit (cfg) group;
        };
        "${cfg.cacheDir}/ccache.conf"."L+".argument = ccacheConfigFile;
      };

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
              export CCACHE_DIR="${cfg.cacheDir}"
              if [ ! -d "$CCACHE_DIR" ]; then
                echo "====="
                echo "Directory '$CCACHE_DIR' does not exist"
                echo "Please create it and ensure that $(whoami) has access"
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

  meta.maintainers = with lib.maintainers; [ rhendric ];
}
