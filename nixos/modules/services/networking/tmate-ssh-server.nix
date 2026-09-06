{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.services.tmate-ssh-server;

  defaultKeysDir = "/etc/tmate-ssh-server-keys";
  edKey = "${defaultKeysDir}/ssh_host_ed25519_key";
  rsaKey = "${defaultKeysDir}/ssh_host_rsa_key";

  keysDir = if cfg.keysDir == null then defaultKeysDir else cfg.keysDir;

  domain = config.networking.domain;
in
{
  options.services.tmate-ssh-server = {
    enable = mkEnableOption "tmate ssh server";

    package = mkPackageOption pkgs "tmate-ssh-server" { };

    host = mkOption {
      type = types.str;
      description = "External host name";
      defaultText = lib.literalExpression "config.networking.domain or config.networking.hostName";
      default = if domain == null then config.networking.hostName else domain;
    };

    port = mkOption {
      type = types.port;
      description = "Listen port for the ssh server";
      default = 2222;
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to automatically open the specified ports in the firewall.";
    };

    advertisedPort = mkOption {
      type = types.port;
      description = "External port advertised to clients";
    };

    keysDir = mkOption {
      type = with types; nullOr str;
      description = "Directory containing ssh keys, defaulting to auto-generation";
      default = null;
    };
  };

  config = mkIf cfg.enable {

    networking.firewall.allowedTCPPorts = optionals cfg.openFirewall [ cfg.port ];

    services.tmate-ssh-server = {
      advertisedPort = mkDefault cfg.port;
    };

    environment.systemPackages =
      let
        tmate-config = pkgs.writeText "tmate.conf" ''
          set -g tmate-server-host "${cfg.host}"
          set -g tmate-server-port ${toString cfg.port}
          set -g tmate-server-ed25519-fingerprint "@ed25519_fingerprint@"
          set -g tmate-server-rsa-fingerprint "@rsa_fingerprint@"
        '';
      in
      [
        (pkgs.writeShellApplication {
          name = "tmate-client-config";
          runtimeInputs = with pkgs; [
            openssh
            coreutils
          ];
          text = ''
            RSA_SIG="$(ssh-keygen -l -E SHA256 -f "${keysDir}/ssh_host_rsa_key.pub" | cut -d ' ' -f 2)"
            ED25519_SIG="$(ssh-keygen -l -E SHA256 -f "${keysDir}/ssh_host_ed25519_key.pub" | cut -d ' ' -f 2)"
            sed "s|@ed25519_fingerprint@|$ED25519_SIG|g" ${tmate-config} | \
              sed "s|@rsa_fingerprint@|$RSA_SIG|g"
          '';
        })
      ];

    systemd.services.tmate-ssh-server = {
      description = "tmate SSH Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/tmate-ssh-server -h ${cfg.host} -p ${toString cfg.port} -q ${toString cfg.advertisedPort} -k ${keysDir}";
      };
      preStart = mkIf (cfg.keysDir == null) ''
        if [[ ! -d ${defaultKeysDir} ]]
        then
          mkdir -p ${defaultKeysDir}
        fi
        if [[ ! -f ${edKey} ]]
        then
          ${pkgs.openssh}/bin/ssh-keygen -t ed25519 -f ${edKey} -N ""
        fi
        if [[ ! -f ${rsaKey} ]]
        then
          ${pkgs.openssh}/bin/ssh-keygen -t rsa -f ${rsaKey} -N ""
        fi
      '';
    };
  };

  meta = {
    maintainers = with maintainers; [ jlesquembre ];
  };

}
