{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.knot-resolver;
  # pkgs.writers.yaml_1_1.generate with additional kresctl validate
  configFile =
    pkgs.runCommandLocal "knot-resolver.yaml"
      {
        nativeBuildInputs = [ pkgs.remarshal_0_17 ];
        value = builtins.toJSON cfg.settings;
        passAsFile = [ "value" ];
      }
      ''
        json2yaml "$valuePath" "$out"
        ${cfg.managerPackage}/bin/kresctl validate "$out"
      '';
in
{
  meta.maintainers = [
    lib.maintainers.vcunat # upstream developer
  ]
  ++ lib.teams.flyingcircus.members;

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
    package = lib.mkPackageOption pkgs "knot-resolver_6" {
      example = "knot-resolver_6.override { extraFeatures = true; }";
    };
    managerPackage = lib.mkPackageOption pkgs "knot-resolver-manager_6" { };
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

    assertions = [
      {
        assertion = lib.versionAtLeast cfg.package.version "6.0.0";
        message = ''
          services.knot-resolver only works with knot-resolver 6 or later.
          Please use services.kresd for knot-resolver 5.
        '';
      }
    ];

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

    systemd.packages = [ cfg.package ]; # the unit gets patched a bit just below
    systemd.services."knot-resolver" = {
      wantedBy = [ "multi-user.target" ];
      path = [ (lib.getBin cfg.package) ];
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
