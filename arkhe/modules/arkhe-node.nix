# Perfil `arkhe-node`: runtime HTTP do kernel Arkhe.
#
# Requer o overlay deste repositório:
#   nixpkgs.overlays = [ inputs.nixpkgs-arkhe.overlays.default ];
{ config, lib, pkgs, ... }:

let
  cfg = config.services.arkheNode;
in
{
  options.services.arkheNode = {
    enable = lib.mkEnableOption "runtime Arkhe (perfil arkhe-node)";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.arkhe.arkhe-runtime;
      defaultText = lib.literalExpression "pkgs.arkhe.arkhe-runtime";
      description = ''
        Pacote do runtime. Exige o overlay do nixpkgs-arkhe
        (`nixpkgs.overlays = [ inputs.nixpkgs-arkhe.overlays.default ];`).
      '';
    };

    listen = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1:8788";
      description = "Endereço de escuta, exportado como ARKHE_LISTEN.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8788;
      description = "Porta TCP aberta quando `openFirewall` está ativo.";
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        Arquivo com DATABASE_URL, ARKHE_API_TOKEN, ARKHE_ACTOR e
        ARKHE_TENANT_ID. Obrigatório quando o serviço está habilitado.
      '';
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Abrir `port` no firewall.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.environmentFile != null;
        message = "services.arkheNode.environmentFile é obrigatório.";
      }
    ];

    users.groups.arkhe = { };

    users.users.arkhe = {
      isSystemUser = true;
      group = "arkhe";
      home = "/var/lib/arkhe";
    };

    systemd.services.arkhe-runtime = {
      description = "Arkhe runtime";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];

      environment = {
        ARKHE_LISTEN = cfg.listen;
        RUST_LOG = "info";
      };

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/arkhe-runtime";
        User = "arkhe";
        Group = "arkhe";
        StateDirectory = "arkhe";
        EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;
        Restart = "on-failure";
        RestartSec = 5;

        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ReadWritePaths = [ "/var/lib/arkhe" ];
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        SystemCallArchitectures = "native";
        CapabilityBoundingSet = "";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
      };
    };

    networking.firewall.allowedTCPPorts = lib.optional cfg.openFirewall cfg.port;
  };
}
