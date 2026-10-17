{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.ld-audit-search-mod;

  settingsFormat = pkgs.formats.yaml { };

  configFile = settingsFormat.generate "ld-audit-search-mod.yaml" cfg.settings;

in
{
  meta.maintainers = with lib.maintainers; [ atry ];

  options.programs.ld-audit-search-mod = {
    enable = lib.mkEnableOption ''
      ld-audit-search-mod, a LD_AUDIT module that modifies the library search behavior of ld.so.

      This is useful for making programs that use dlopen() work correctly in NixOS environments
      by automatically adding appropriate library search paths. See
      <https://github.com/DDoSolitary/ld-audit-search-mod> for more information
    '';

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = settingsFormat.type;
        options = {
          log_level = lib.mkOption {
            type = lib.types.enum [
              "trace"
              "debug"
              "info"
              "warning"
              "error"
              "critical"
              "off"
            ];
            default = "warning";
            description = ''
              Logging level for ld-audit-search-mod output defined in [spdlog](https://github.com/gabime/spdlog/blob/f1d748e5e3edfa4b1778edea003bac94781bc7b7/include/spdlog/common.h#L256-L262)
            '';
          };

          env = lib.mkOption {
            type = lib.types.listOf settingsFormat.type;
            default = [ ];
            example = [
              {
                cond = {
                  rtld = "any";
                  exe = "firefox";
                };
                setenv = {
                  DISPLAY = ":0";
                };
                unsetenv = [ "WAYLAND_DISPLAY" ];
              }
            ];
            description = ''
              Environment variable modification rules.

              Each rule contains:
              - cond: Condition object specifying when the rule applies (e.g., {rtld = "any"; exe = "some-program";})
              - setenv: Attribute set of environment variables to set (e.g., {VAR_NAME = "value";})
              - unsetenv: List of environment variable names to unset (e.g., ["VAR1" "VAR2"])
            '';
          };

          rules = lib.mkOption {
            type = lib.types.listOf settingsFormat.type;
            default = [ ];
            example = [
              {
                cond = {
                  rtld = "nix";
                  lib = ".*";
                };
                libpath.save = true;
                default = {
                  enable = true;
                  prepend = [
                    { saved = "libpath"; }
                    { dir = "/some/lib/path"; }
                  ];
                  filter = [ { include = "/nix/store/.*"; } ];
                };
              }
            ];
            description = ''
              Library search modification rules.

              Each rule is an attribute set that can contain:
              - cond: Condition specifying when the rule applies
              - rpath, runpath, libpath, config, default: Search phase configurations
              - rename: Library renaming rules

              Each search phase (rpath, runpath, default) can contain:
              - prepend: List of paths to add to search path
              - filter: List of include/exclude filters
              - save: Whether to save results for later phases

              The 'default' phase also supports an 'enable' field.
            '';
          };
        };
      };
      default = { };
      description = ''
        Configuration for ld-audit-search-mod. This will be serialized to YAML format.

        The configuration file defines how the audit module should modify library search behavior for different programs and conditions. It supports environment variable modification and complex library search path manipulation.
      '';
    };

    package = lib.mkPackageOption pkgs "ld-audit-search-mod" { };

    libraries = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      description = ''
        Fallback libraries that automatically become available when a program cannot find its required shared objects from either its own rpath/runpath or LD_LIBRARY_PATH.

        This can be used as a replacement for programs.nix-ld.libraries for unpatched binaries.
      '';
      default = [ ];
    };
  };

  config = lib.mkIf cfg.enable {

    environment = {
      sessionVariables = {
        LD_AUDIT = [ "${cfg.package}/lib/libld-audit-search-mod.so" ];
        LD_AUDIT_SEARCH_MOD_CONFIG = toString configFile;
        GLIBC_TUNABLES = [
          # Increase the maximum number of static TLS blocks to 2000, otherwise this module would conflict with `services.matrix-synapse.withJemalloc` and other options that use jemalloc, which set LD_PRELOAD and use static TLS blocks.
          "glibc.rtld.optional_static_tls=2000"
        ];
      };

      # Use ld.so from stdenv for unpatched binaries
      ldso = lib.mkDefault pkgs.stdenv.cc.bintools.dynamicLinker;
      stub-ld.enable = false;
    };

    # Add a rule for non-Nix programs to search the fallback library paths
    programs.ld-audit-search-mod.settings.rules = [
      {
        cond.rtld = "any";
        default.prepend = map (pkg: { dir = "${lib.getLib pkg}/lib"; }) cfg.libraries;
      }
    ];

    # We currently take all libraries from systemd and nix as the default.
    # Is there a better list?
    programs.ld-audit-search-mod.libraries = with pkgs; [
      zlib
      zstd
      stdenv.cc.cc
      curl
      openssl
      attr
      libssh
      bzip2
      libxml2
      acl
      libsodium
      util-linux
      xz
      systemd
    ];
  };
}
