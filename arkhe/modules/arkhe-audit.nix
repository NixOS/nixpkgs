# Perfil `arkhe-audit`: estação de verificação offline.
#
# Não habilita nenhum serviço de rede: o perfil de auditoria é offline por
# definição. Apenas instala o verificador e prepara um diretório de trabalho.
{ config, lib, pkgs, ... }:

let
  cfg = config.services.arkheAudit;
in
{
  options.services.arkheAudit = {
    enable = lib.mkEnableOption "estação de auditoria Arkhe (perfil arkhe-audit)";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.arkhe.arkhe-verify;
      defaultText = lib.literalExpression "pkgs.arkhe.arkhe-verify";
      description = ''
        Pacote do verificador. Exige o overlay do nixpkgs-arkhe
        (`nixpkgs.overlays = [ inputs.nixpkgs-arkhe.overlays.default ];`).
      '';
    };

    workspace = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/arkhe-audit";
      description = "Diretório para bundles, provas e checkpoints recebidos.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      cfg.package
    ];

    users.groups.arkhe-audit = { };

    users.users.arkhe-audit = {
      isSystemUser = true;
      group = "arkhe-audit";
      home = cfg.workspace;
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.workspace} 0700 arkhe-audit arkhe-audit -"
    ];
  };
}
