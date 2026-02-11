{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.knot-resolver;
  # pkgs.writers.yaml_1_1.generate with additional kresctl validate
  configFile = pkgs.callPackage (
    {
      runCommandLocal,
      remarshal_0_17,
      stdenv,
    }:
    runCommandLocal "knot-resolver.yaml"
      {
        nativeBuildInputs = [ remarshal_0_17 ];
        value = builtins.toJSON cfg.settings;
        passAsFile = [ "value" ];
      }
      ''
        json2yaml "$valuePath" "$out"
        ${
          # We skip validation if the build platform cannot execute # the binary targeting the host platform.
          lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
            ${cfg.managerPackage}/bin/kresctl validate "$out"
          ''
        }
      ''
  ) { };
in
{
  meta.maintainers = [
    lib.maintainers.vcunat # upstream developer
    lib.maintainers.leona
    lib.maintainers.osnyx
  ];

  ###### interface
  options.services.knot-resolver = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to enable knot-resolver (version 6) domain name server.
        DNSSEC validation is turned on by default.
        If you want to use knot-resolver 5, please use services.kresd.
      '';
    };
    managerPackage = lib.mkPackageOption pkgs "knot-resolver-manager_6" {
      example = "pkgs.knot-resolver-manager_6.override { extraFeatures = true; }";
    };
    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = (pkgs.formats.yaml { }).type;
        options = {
          network.listen = lib.mkOption {
            type = lib.types.listOf (
              lib.types.submodule {
                freeformType = (pkgs.formats.yaml { }).type;
              }
            );
            description = "List of interfaces to listen to and its configuration.";
            default = [
              {
                interface = [ "127.0.0.1" ];
                kind = "dns";
                freebind = false;
              }
            ]
            ++ lib.optionals config.networking.enableIPv6 [
              {
                interface = [ "::1" ];
                kind = "dns";
                freebind = false;
              }
            ];
            defaultText = lib.literalExpression ''
              [
                {
                  interface = [ "127.0.0.1" ];
                  kind = "dns";
                  freebind = false;
                }
              ]
              ++ lib.optionals config.networking.enableIPv6 [
                {
                  interface = [ "::1" ];
                  kind = "dns";
                  freebind = false;
                }
               ];
            '';
          };
          workers = lib.mkOption {
            type = lib.types.oneOf [
              (lib.types.enum [ "auto" ])
              lib.types.ints.unsigned
            ];
            default = 1;
            description = ''
              The number of running kresd (Knot Resolver daemon) workers. If set to 'auto', it is equal to number of CPUs available.
            '';
          };
        };
      };
      default = { };
      description = ''
        Nix-based (RFC 42) configuration for Knot Resolver.
        For configuration reference (described as YAML) see
        <https://www.knot-resolver.cz/documentation/latest/config-overview.html>
      '';
    };
  };

  ###### implementation
  config = lib.mkIf cfg.enable {
    users.users.knot-resolver = {
      isSystemUser = true;
      group = "knot-resolver";
      description = "Knot-resolver daemon user";
    };
    users.groups.knot-resolver = { };
    networking.resolvconf.useLocalResolver = lib.mkDefault true;

    environment = {
      etc."knot-resolver/config.yaml".source = configFile;
      systemPackages = [
        # We just avoid including the other binaries, e.g. supervisorctl.
        (pkgs.runCommandLocal "knot-resolver-cmds" { } ''
          mkdir -p "$out/bin"
          ln -s '${cfg.managerPackage}/bin/kresctl' "$out/bin/"
        '')
      ];
    };

    systemd.packages = [ cfg.managerPackage.kresd ]; # the unit gets patched a bit just below
    systemd.services."knot-resolver" = {
      wantedBy = [ "multi-user.target" ];
      stopIfChanged = false;
      reloadTriggers = [
        configFile
      ];
      serviceConfig = {
        ExecStart = "${cfg.managerPackage}/bin/knot-resolver";
        ExecReload = "${cfg.managerPackage}/bin/kresctl reload";

        StateDirectory = "knot-resolver";
        StateDirectoryMode = "0770";

        RuntimeDirectory = "knot-resolver";
        RuntimeDirectoryMode = "0770";

        CacheDirectory = "knot-resolver";
        CacheDirectoryMode = "0770";
      };
    };
  };
}
