{ config, pkgs, lib, ... }:

with lib;

let cfg = config.services.ollama;

in {
  options = {
    services.ollama = {
      enable = mkEnableOption (lib.mdDoc ''
        Ollama backend service.
        Run state-of-the-art AI large language models (LLM) similar to ChatGPT locally with privacy
        on your personal computer.

        This module provides the `ollama serve` backend runner service so that you can run
        `ollam run <model-name>` locally in a terminal; this will automatically download the
        LLM model and open a chat. See <https://github.com/jmorganca/ollama#quickstart>.
        The model names can be looked up on <https://ollama.ai/library> and are available in
        varying sizes to fit your CPU, GPU, RAM and disk storage.
        See <https://github.com/jmorganca/ollama#model-library>.

        Optional: This module is intended to be run locally, but can be served from a (home) server,
        ideally behind a secured reverse-proxy.
        Look at <https://nixos.wiki/wiki/Nginx> or <https://nixos.wiki/wiki/Caddy>
        on how to set up a reverse proxy.

        Optional: This service doesn't persist any chats and is only available in the terminal.
        For a convenient, graphical web app on top of it, take look at
        <https://github.com/ollama-webui/ollama-webui>, also as `ollama-webui` in Nixpkgs.
      '');

      ollama-package = mkPackageOption pkgs "ollama" { };

      host = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = lib.mdDoc ''
          The host/domain name under which the Ollama backend service is reachable.
        '';
      };

      port = mkOption {
        type = types.port;
        default = 11434;
        description = lib.mdDoc "The port for the  Ollama backend service.";
      };

      cors_origins = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "https://myserver:8080,http://10.0.0.10:*";
        description = lib.mdDoc ''
          Allow access from web apps that are served under some (different) URL.
          If a web app like Ollama-WebUI is available/served on `https://myserver:8080`,
          then add this URL here. Otherwise the Ollama backend server will reject the
          UIs request and return 403 forbidden due to CORS.
          See <https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS>.
        '';
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Open ports in the firewall for the Ollama backend service.";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.ollama = {
      description = "Ollama: A backend service for local large language models (LLM).";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment = {
        OLLAMA_HOST = "${cfg.host}:${toString cfg.port}";
        OLLAMA_ORIGINS = cfg.cors_origins;
        # Where to store LLM model files.
        # Directory is managed by systemd DynamicUser feature, see below.
        HOME = "%S/ollama";
        OLLAMA_MODELS = "%S/ollama/models";
      };

      serviceConfig = {
        ExecStart = "${lib.getExe cfg.ollama-package} serve";
        # Systemd takes care of username, user id, security & permissions
        # See https://0pointer.net/blog/dynamic-users-with-systemd.html
        # Almost nothing on the disk is readable for this dynamic user; only a few places writable:
        # See https://www.freedesktop.org/software/systemd/man/latest/systemd.exec.html#RuntimeDirectory=
        DynamicUser = "true";
        Type = "simple";
        Restart = "on-failure";
        RestartSec = 3;
        WorkingDirectory = "/var/lib/ollama";
        # Persistent storage for model files, i.e. /var/lib/<StateDirectory>
        StateDirectory = [ "ollama" ];
      };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };

  };
  meta.maintainers = with lib.maintainers; [ onny malteneuss ];
}
